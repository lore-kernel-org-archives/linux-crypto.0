From: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Subject: Re: [PATCH 3/7] crypto/testmgr: add testing for arc4 based on
 ecb(arc4)
Date: Thu, 8 Apr 2010 09:58:10 +0200
Message-ID: <20100408075810.GA9722@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
 <1270280969-11357-4-git-send-email-sebastian@breakpoint.cc>
 <1270621793.31184.50.camel@mj>
 <20100407092907.GB29993@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Pavel Roskin <proski-mXXj517/zsQ@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100407092907.GB29993-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2010-04-07 17:29:07 [+0800]:

>Sebastian, how about precomputing the IV and provide them directly
>as a hex array?
>
>To test arc4_setup_iv itself, you can add an alg_test_arc4 function
>(like alg_test_crc32) that tests IV generation specifically.
>
>Alternatively, just add an alg_test_arc4 that computes the IV
>before calling alg_test_skcipher.

I take a look at this.

>Cheers,

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
