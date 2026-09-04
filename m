Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CD332143D
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 02:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788490204; cv=none; b=TCyFZk0UqIcnjRctE/Z3VGENIBSO/RKUKJZqbmaqXHV1jqa4hDRAt3uqwhdBJZQlqSXnfaWdj+90aFUc42qWsGghFPBqn6pIx97GzbddV/FIvm2ANRaeoiJESaBjiHfX3tNafgFBAe1mfTkew316vlp7diFVU6ZMoSSLJmNrTXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788490204; c=relaxed/simple;
	bh=3MvmmwZvg6iNS8mwVIF3MT/6jIAt9thoEh08Kl3QeSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbQfOB42ZwhxTq6stgxGjxqP1MPRUsIGIJKJJHKT3tLC0ieC7bfpljOHSxZe+z9g3cCtPClZDXi3PevTNVF44jMa/FuSyOzRuU1YdFYJKCl5lZx3xmWLxExKK3uaeftBr0gXGTgM9TSqdw9I1glsnNHrnD0OApakBaBFKCped3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p+BSAFKZ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p+BSAFKZ"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-398e9698a70so469770a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 19:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788490201; x=1789095001; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PG96oKZZP2N6Xo9cvn741u/vr6DaKEDABY2UEKMrlX4=;
        b=p+BSAFKZoEMCJX3Et+074ZqcSeh6VnY0F6Dh1XF4ar6b1WRKTyJKjyhvxjzvwhWAZl
         0oeTfzKfaOtu52ZHQyCZWwHxxjEBToZTcRPBqou9hEtAGZV4T/otq1PpZQY9dVD1eu+I
         SrrecpSeXsur2rtKrDGt4MPBniXZBg/TeR8gFW+jSXwAF0Wy2FuOwLLOMB79MvJxVVnJ
         b1oWzM8aD+w/SAdDGoNjuf69PeWPQX9XyCkCQ8/u+xqBoAZ6rYi9FQqKWyTWaJZkVP/T
         T2KiN419nXrXdgk/cMOpUVJ0ozw2p9OYwNH6PbJgC/fOeWjw6vyQunIKDHMZ6MZKmUQF
         xxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788490201; x=1789095001;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PG96oKZZP2N6Xo9cvn741u/vr6DaKEDABY2UEKMrlX4=;
        b=e46NiSgxk8F8fEYMpx6YegaaHrCtnK06fCdtFQ3H4WYmzxHt5rDGTCEBrHLfBQMGCH
         TNc+RF7Mq6JH4LHUYpMivCnCRVARI9ROIuD+ofky03AWAjbWyZqe+4EZq0FYgjWTseHo
         nVEHWvz47dLs8Bg/KzqMij2f5jUL4EKztSPsq3mH3pKqQ6IBh+Bzd7pdHauLYQAcUPKp
         Q/lqxKfI1uFct3tJgF80RfE0IdY1YTA0zBMV4xgBaWBBFFFfiFoa5knxjfep91Zp1wm+
         TP2HqyEol38aKztX4aWm+7ApDvvcM9IbwXbx047QPrq3GJaHdQu6BCC7gmRloyJnqc4D
         Ozjg==
X-Forwarded-Encrypted: i=1; AKwUvBxHNw6rLWC7rm4nbl4HKGfahGeZE8H2sCa1AEivph6VBN1fkWsu0PhqYzcsIJFt4oI08elZ/EEXge8Vr74=@vger.kernel.org
X-Gm-Message-State: AFuF++nuuY6kzfew22P1e+zdueXxV3FfCG6W61Mk1bj8bk0+dxLIV3Y1
	hSrU9D6krU12XzJYJHCXpCf4Ou/IrwlbPu32uOQK2EmP1RqdhLE6SUnR
X-Gm-Gg: AYBFou0deLnyl/LCCkEvkGmvn0IZ0Bg46e/lnS9Y10dqCvIu4hSIn1BbBjBxRJ6ry/g
	3ycrkx2JALmRH3fzQNed/Xf473IidStr1EYtKlcR3IZmRpdlhAI3RUJXLs3p4Fx5jpyzTJqRKNm
	XfzYgJioqV2JOGfq69ypFGXRQo2BNID9iejxCarheDPX7HdlsrnO5UBn2MdZU/pq5Ov5TUIB7V/
	zUe54T7xusNgPfqMKWZ3YhNed6uMnlwDgNZPZVHtCXrlJxIgpNsXGQWeZYK1kCW+MW0RQowh5aH
	VQJ1kt+Gq52HHEVrM0gy1GO9H5CltZ6dA+9REL0uptJTC9Vm6+hZ7GZp2715HYFgswEMmXVxrcC
	lFWk8W8lhBfJqmTAjuthHIb2qe4L2Wj8x4Lft4XWC2UA1i05afthea29Ao/JVUfyFPyxZFh+Oiu
	nN9sYKIvgOSEbhKaZgLO3PMxG/eZYguWhKa3AOTBRE6Bsj9zfckaU/mHIUWrH8Scuvm656lTG7v
	XsM8obGuWxO2TW0qMQ=
X-Received: by 2002:a17:90b:4c86:b0:395:5f43:4ec4 with SMTP id 98e67ed59e1d1-39b25f78ab8mr4417800a91.0.1788490201512;
        Thu, 03 Sep 2026 19:50:01 -0700 (PDT)
Received: from kernel ([103.219.206.87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm3762634eec.16.2026.09.03.19.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 19:50:01 -0700 (PDT)
Date: Fri, 4 Sep 2026 08:19:53 +0530
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: clabbe@baylibre.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: skhan@linuxfoundation.org, me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: amlogic: Fix IRQ handler return value and
 fallthrough logic
Message-ID: <apox0f2D6bYOYOnj@kernel>
References: <20260821151243.8125-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821151243.8125-1-raizudeen.kerneldev@gmail.com>

On Fri, Aug 21, 2026 at 08:42:43PM +0530, Mohamad Raizudeen wrote:
> In irqreturn_t_meson_irq_handler(), when an interrupt matches a flow
> but the status register is empty, the driver prints an error but
> doesn't return. It falls through the loop and incorrectly prints an
> `unknown irq` message.
> 
> Fix this by returning IRQ_HANDLED immediately after the error print.
> 
> Additionally, the handler returns IRQ_HANDLED for genuinely unknown
> interrupts. This masks false interrupts and prevents the kernel from
> detecting interrupts. Return IRQ_NONE instead for unhandled
> interrupts.
> 
> Cc: stable@vger.kernel.org
> Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
> index 6cb33949915f..302b398405e2 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
> @@ -38,11 +38,12 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
>  				return IRQ_HANDLED;
>  			}
>  			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
> +			return IRQ_HANDLED; 
>  		}
>  	}
>  
>  	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
> -	return IRQ_HANDLED;
> +	return IRQ_NONE;
>  }
>  
>  static struct meson_alg_template mc_algs[] = {
> -- 
> 2.53.0
>
Hi,

Just following up on this patch. Please let me know if you have any
feedback or if further changes are needed.

Thanks,
Mohamad Raizudeen
