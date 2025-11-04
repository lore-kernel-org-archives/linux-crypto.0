Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E93023F424;
	Tue,  4 Nov 2025 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762256722; cv=none; b=Mg+4xC0lKOVsGU9Vepoa/G7rXPLFD3tmjD9juW0CL7Nnxa7vyKI0c5rdSPMo9avO2+5gwcFRC0ZzGHgzhwhIUqC26rK38kA1hu/zicp+SRp4gbn90+8nzMGL4y5d0/n9oTAyAAg92/DQiS3mcAAtrwtLxNMerWLcKXu+0YwkuhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762256722; c=relaxed/simple;
	bh=/KeIX0gnZtIj01vLQnJBFwOkNI+4nbGTV0oEEsEqnxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=s8IpB3Pin24jw655QEgHNvDwEgmBrJddxxeiDPqSHtRdxdOH6daaxT+rp/2zMCD0UsmUG1JKWnPCnjWDmZVaNB+Hfhp5NnS4TR8ZBrFH4T9Uq62vwlZglKXLADjw0xgkJkKB5+2nPRmQKUpUSNS2AM2wrhrhWPIqvDWxGZuw7M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 5A4Bis4A075105;
	Tue, 4 Nov 2025 20:44:54 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 5A4Bir8J075099
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 4 Nov 2025 20:44:54 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>
Date: Tue, 4 Nov 2025 20:44:53 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: padata: Is padata_find_next() thread-safe?
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
 <68c34150.050a0220.3c6139.0045.GAE@google.com>
Content-Language: en-US
Cc: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>,
        daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <68c34150.050a0220.3c6139.0045.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav201.rs.sakura.ne.jp

syzbot is reporting possibility of recursive locking at
https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b .
If this is a false positive report, the fix will be as simple as

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -253,7 +253,7 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd, int cpu,
 
 	reorder = per_cpu_ptr(pd->reorder_list, cpu);
 
-	spin_lock(&reorder->lock);
+	spin_lock_nested(&reorder->lock, 1);
 	if (list_empty(&reorder->list))
 		goto notfound;

. But I don't know if there is a possibility of AB-BA deadlock.

Can a sequence shown below possible? If it is possible, how is calling
padata_find_next() with a spinlock already held by caller introduced by
commit 71203f68c774 ("padata: Fix pd UAF once and for all") thread-safe?

  struct padata_list list[2];

  CPU 0:                         CPU 1:

  spin_lock(&list[0].lock);
                                 spin_lock(&list[1].lock);
  spin_lock_nested(&list[1].lock, 1);
                                 spin_lock_nested(&list[0].lock, 1);
  do_something();
                                 do_something();
  spin_unlock(&list[1].lock);
                                 spin_unlock(&list[0].lock);
  spin_unlock(&list[0].lock);
                                 spin_unlock(&list[1].lock);

