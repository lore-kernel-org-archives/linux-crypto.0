From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
 cipher
Date: Sun, 14 Feb 2010 21:42:54 +0100
Message-ID: <20100214204253.GA19275@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100209073718.GA17612@gondor.apana.org.au>
 <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
 <20100209204519.GC26258@gondor.apana.org.au>
 <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
 <20100209214522.GA27002@gondor.apana.org.au>
 <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58757 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729Ab0BNUm6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2010 15:42:58 -0500
Content-Disposition: inline
In-Reply-To: <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Andrzej Siewior | 2010-02-12 09:42:28 [+0100]:

>+static void arc4_ivsetup(struct arc4_ctx *ctx, u8 *iv)
> {
>-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
>+	if (unlikely(!ctx->new_key))

That should be likely(). Do you want me resend the whole thing? Haven't
noticed anything else :)

>+		return;
>+	memcpy(iv, &ctx->iv, sizeof(ctx->iv));
>+	ctx->new_key = 0;
>+}

Sebastian
