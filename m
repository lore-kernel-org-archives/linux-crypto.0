Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF3130C62A;
	Thu,  6 Nov 2025 09:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762422107; cv=none; b=m6CHz8onhherYKG+jvZT6pfcLmR80/o+9sna0osaD6KEzXuHhendTEmLF+T/DA6cLUb1WEo3tJpx0UTEGXIuFihhwHePple3bNY+csulGypw4TQOFSDjTh2ZcNSP3//iM/IJUJ8kJkxK2gGZPuyqN/4rHx+txlLBhqcZqTVTJ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762422107; c=relaxed/simple;
	bh=Nl+7Ti9cZP1QVjMZtE51MrY6WoQ7aIeVCd1oIPCIyv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTqMoKfxu50G6mPGzNAJzGfg8gd1F784BEnJ9k48saZRCHKPcXEAL1k1ufOBiP/IZ4pl/bh6nDO2rIc5+XEWawazz01pkbgJVzY67NLiCeWdj7cOUL6joOghp5LVW2IZjOLvk64G2gVTmr/WOfsgAEcmiIIFSCQosxCzOBi9TCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 5A69fKlA022238;
	Thu, 6 Nov 2025 18:41:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 5A69fKtC022235
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 6 Nov 2025 18:41:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <60778a1e-c29d-4d41-8272-9e635d9ff427@I-love.SAKURA.ne.jp>
Date: Thu, 6 Nov 2025 18:41:19 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: padata: Is padata_find_next() thread-safe?
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>,
        daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
References: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
 <68c34150.050a0220.3c6139.0045.GAE@google.com>
 <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>
 <aQxqTiUUrDmF5M_X@gondor.apana.org.au>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <aQxqTiUUrDmF5M_X@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav403.rs.sakura.ne.jp
X-Virus-Status: clean

On 2025/11/06 18:28, Herbert Xu wrote:
> On Tue, Nov 04, 2025 at 08:44:53PM +0900, Tetsuo Handa wrote:
>> syzbot is reporting possibility of recursive locking at
>> https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b .
>> If this is a false positive report, the fix will be as simple as
> 
> Yes it's a false positive as reorder->lock is never the same as
> squeue->serial.lock.

OK. But what is about the "Can a sequence shown below possible?" part?

> 
> However, they both have the same data type which is why lockdep
> is confused.
> 
> Please provide a patch that sets the class for one of them to
> something different.  For example, change the lockdep class for
> reorder->lock using lockdep_set_class and the problem should go
> away.

Is using _nested(lock, 1) wrong?

