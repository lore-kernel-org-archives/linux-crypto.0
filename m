Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C9417B50F;
	Sat,  4 Apr 2026 03:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775271970; cv=none; b=TGMfuu28VHlkMpXePOKJdMqBPjOjnzFrE+8zG1h/VGA5tqcrVvVZfUisF84kljE4Pw+dDDwIInJApb1XnADrI8pfUN2lOJTLo1XJQZ/QDc9IX2pZ8OFlrOSrCbRe4cRC3u+StHCNxIFi7evwDvcee5oqisJILiyrujn74PUb3bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775271970; c=relaxed/simple;
	bh=J+5f2/xKMlELbr2RQDb0Rm2Wx+9Wjg+sZrFfHdyN5zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOj1IULlIovwn4INOR/ZeIWgBTLvz9n6RN1RF32yoZIDQ063b6kC6XPvMdc+qtQAauvuqGG8a6AtJdiy8wel4sL9yDpaRTi7PvWA0o+p/4p7iy/v/aK/rd3NK33IvakQgOX1a0Pi70RjvTOAvenTU0Ee6u5FE39bA7s0elvFqbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lfu60YtI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lfu60YtI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bFioZJJ2al5utKUcrKNuxlcIi0UlAOAFES3C0VdYpxk=; 
	b=lfu60YtIVRyupaXuX3cUveMgOfJcgEqyYsPYolGwr6gPUIx57it3Hf/1tLTuqy9RA89/gyW/NBG
	+ZhkKDfQR5bP11JPOEGOTKM8/znLIFhtheB/kHAhv3/HHIG8X4Ij/+Sa5+agoG1WEPV2Sn/7O99t9
	Ouu51B+KWSICLMkB1gkS2amYohkCD/tYP//KCuZjoGovxIpu31dvCxvvezL88zKNp7lirirWwyCy5
	KcuKiiJB5K/eimeu+cRP207vQgjYAtHcxUMMbWcrVrQKdZoN5CZ+Hc1JP7xZojdEn7QUvJyoX76Li
	q+oG6r2vNuU4078u5qOrvqJOrZEIL5HbbdjA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w8qvB-003ia7-1W;
	Sat, 04 Apr 2026 11:05:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Apr 2026 11:05:56 +0800
Date: Sat, 4 Apr 2026 11:05:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: algif_aead - Fix minimum RX size check for decryption
Message-ID: <adCAFOgQ0y_I7SC7@gondor.apana.org.au>
References: <69cfeb9a.050a0220.2dbe29.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69cfeb9a.050a0220.2dbe29.0012.GAE@google.com>

On Fri, Apr 03, 2026 at 09:32:26AM -0700, syzbot wrote:
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 5987 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
> RIP: 0010:memcpy_sglist+0x420/0x730 crypto/scatterwalk.c:177
> Code: e8 b5 b9 52 fd f6 c3 01 0f 85 0a 01 00 00 e8 c7 b4 52 fd 4c 89 f3 eb 07 e8 bd b4 52 fd 31 db 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 1d 02 00 00 41 8b 07 89 44 24 04 49 8d 7d
> RSP: 0018:ffffc900035a7698 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888026dc1e80
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff88802543b200 R14: ffff888033865080 R15: 0000000000000008
> FS:  000055556d3e1500(0000) GS:ffff888125457000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000004580 CR3: 0000000035e06000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  _aead_recvmsg crypto/algif_aead.c:186 [inline]

Again this is an existing bug that has been uncovered:

---8<---
The check for the minimum receive buffer size did not take the
tag size into account during decryption.  Fix this by adding the
required extra length to the variable less.

Reported-by: syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index dda15bb05e89..b0811eb7d665 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -144,6 +144,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (usedpages < outlen) {
 		size_t less = outlen - usedpages;
 
+		if (!ctx->enc)
+			less += as;
 		if (used < less) {
 			err = -EINVAL;
 			goto free;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
