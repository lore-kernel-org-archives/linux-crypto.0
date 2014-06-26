From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Using s5p-sss hw crypto causes ipsec to break
Date: Thu, 26 Jun 2014 14:35:44 +0800
Message-ID: <20140626063544.GA17608@gondor.apana.org.au>
References: <CAPz6YkUtGt61YNcGh2sYhaL=U5JMSOu26DvuKXuvp-oxi9ftBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dianders@chromium.org,
	ch.naveen@samsung.com, linux-samsung-soc@vger.kernel.org,
	vzapolskiy@gmail.com
To: Sonny Rao <sonnyrao@chromium.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPz6YkUtGt61YNcGh2sYhaL=U5JMSOu26DvuKXuvp-oxi9ftBw@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sonny Rao <sonnyrao@chromium.org> wrote:
> Hi, I've been investigating an issue relating to hardware crypto which
> is that when I enable the s5p-sss module for hardware cryptographic
> acceleration on Samsung Exynos SoCs the in-kernel IPSec seems to
> break, although cryptographic operations on filesystems/block devices
> using this driver seem to work fine.
> 
> Originally we were looking at an older kernel (3.8 with patches), but
> I've now verified on linux-next from 20140612 (after 3.15) with a few
> additional patches (to enable both s5p-sss and Exynos5420) that this
> is still the case.
> 
> It looks like what is happening in the kernel is that IPsec ends up
> with this callstack
> 
> esp_output()-> crypto_aead_givencrypt()->
> crypto_authenc_givencrypt()-> eseqiv_givencrypt() ->
> crypto_ablkcipher_encrypt()
> 
> 
> which calls into the s5p-sss driver and that is returning -EINPROGRESS
> (or possibly -EBUSY), and that is passed all the way back up the call
> stack and that seems to be treated as an error condition by the ipsec
> stack.
> 
> For example esp_output does this:
> 
>       err = crypto_aead_givencrypt(req);
>        if (err == -EINPROGRESS)
>                goto error;
> 
>        if (err == -EBUSY)
>                err = NET_XMIT_DROP;
> 
> So, I'm not sure how this is supposed to work, or if s5p-sss is doing
> something wrong.

Something else must be happening because EINPROGRESS is meant to
be handled by xfrm_output_resume (which gets called on the normal
path as well as on the actual resume path).

So I don't think this is your problem.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
