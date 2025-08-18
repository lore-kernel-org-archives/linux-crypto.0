Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EB118E377;
	Mon, 18 Aug 2025 12:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755519752; cv=none; b=tzURsKRRvn10J4/MBTM+yi/RNExt5TFs3STT0H4thRPcVbBF/oRU3MfOdqFTw0eFtzARs16tiygvlaQZ3VfsEut0FpiabzjuSofiSW+zNqoMcUI7rhpYwtxykY9b8faVwabOAogmI4M6gfh1Y7D8ibsz4STPWI/almX2NjIz2HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755519752; c=relaxed/simple;
	bh=2m4wQQ0qQ5pprB5fSpolkskpdRUV8gHXNZ1nABiTFq0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=p0T7Whs9YXwIS178/uZZpb6o9NDpe55qsJOuQdXuG/HLasF2waEEYEGFiYnf6E0StmNtcAwcb71SDSK/5DK1EiPxdXcFkKSDjvcAaW8ul4Vr7YQEfEU3faJT/SbSYJ++rowyZ1C6mFXtyjp1z/R49jtHAvyhnpDaBG5ArJ4mk5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=RzUm1anK; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="RzUm1anK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755519439; bh=VUQvA4h/lH5Rfou89T5tCdvr9PQMo/U76xMBhIk7dRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzUm1anKI88ETkc2pqSz3Ccuae4EBr/BWFqLbr7DSAq3xgD3HEYcEuda6PpSxMkz0
	 HyJ9QcRGEzDaGdTZx+5xCipwBMkLM7IN+Nbin5gUVI1T3VdVxY7a2COUsIx83z9eqA
	 cQeDuZ765MB/w7j4EafpjPgUa3i3R57BlNnun8c8=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrszc13-1.qq.com (NewEsmtp) with SMTP
	id 450AC0EF; Mon, 18 Aug 2025 20:17:16 +0800
X-QQ-mid: xmsmtpt1755519436twh4hb5ug
Message-ID: <tencent_50604BE61B0A2525BA07BB9033239E401B08@qq.com>
X-QQ-XMAILINFO: N7h1OCCDntujq0MQEQo6w4HghQOblmM2OAUKDe2ddM/1DrGmXaPcy9/HnBm9ZI
	 LGOFJaWkeqyAdwjKPFQkCeg7dcZZz4cwemjAzSTqFCTSI2fkououkjibN4xERWtX9NhKhi8QR3on
	 i+kh7yx0Nad4Uxs2uRQu6jyim0krNRzPu/hdFQCh9EEshBeakUjTDnVKxIcQSjVjpGU9H/Sc/GSe
	 lYY38b8u+htLXgteaZfPq/BgzIo8juZR0uEtNbAYcxKtcr6cXrLlWjzH2/uQy2AGsKzeH7PeJlCU
	 CX64s2JR7dwLFtzdWiE5dBrot2znqZPFWpZaIcERtrW+nGz5C+ApxBcJdxoUJf4AwJBIi+6TMSHR
	 MZYm/Y+0GKvomXiuNlc/ymnKxFRzSd0gpZaJhN+fnqI3GP73k7/49CRxnlvU1KmDFesIbrmhZ9cg
	 1TV8TUMX3omM8vadAJ7L0CsyU+wrBI9V9Gsd/FyyKNsjdUuNn1GVExEIkMTmAtE2VTFnrYUXH6ea
	 DQu+kGCOtBdzneDgdSRZh6RC/kFHsAzfO9q2ZKjNl0rj3xwhG+Y4KJkxSOt7lQ7sJmF4fbfTAgks
	 AG/J2ffksEpPMpu7sYk1z93EZ52e56Nnr6dyuU9zuIi5WYisk+binTg778UqMVbN0rwNoruWeTLf
	 tbUL/HvObfSQ3OkTMUNLAkvxzz50RSUSUjm9aBIMYLSFTbe3ww5eIO5rUOOwL1qJuYPktgSKG4f7
	 MUYWbH35Dqo46FA9epsHuxGs8JDh/1GISdbkuhvLeEwqWv0K7hdDkrhv/9sgrmv5qc6zmVamWohv
	 vjLwgtOZfT8H8/OouBflu7knqRGbTuKfevN9e3mc0d5U6/1dtcPG8YNuETaFvHAz6z+T0NftHDNl
	 bk7rIauJRxyh/1Xf4k0LPhHemArlnl6tSvJnxvSa0PxozoS23NzoSEZJTRo170XOpKM6JZy9R59d
	 hl5bhgKPVxkwniWqkk/2Oj+skfKEoAd/Og7wJmVH8=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	eadavis@qq.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH V2] crypto: Mark intermediary memory as clean
Date: Mon, 18 Aug 2025 20:17:17 +0800
X-OQ-MSGID: <20250818121716.445262-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aKG_yEuG6F4cqFjf@gondor.apana.org.au>
References: <aKG_yEuG6F4cqFjf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 17 Aug 2025 19:40:56 +0800, Herbert Xu wrote:
> > diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> > index 1266eb790708..4020a6e41b0e 100644
> > --- a/crypto/jitterentropy-kcapi.c
> > +++ b/crypto/jitterentropy-kcapi.c
> > @@ -117,6 +117,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
> >  		pr_warn_ratelimited("Unexpected digest size\n");
> >  		return -EINVAL;
> >  	}
> > +	kmsan_unpoison_memory(intermediary, SHA3_256_DIGEST_SIZE);
> 
> Please change SHA3_256_DIGEST_SIZE to sizeof(intermediary).
Why?
Their values are equal, so why use sizeof to calculate?
Similarly, "if (sizeof(intermediary) != crypto_shash_digestsize(desc->tfm)) {",
why not just use SHA3_256_DIGEST_SIZE?

BR,
Edward

