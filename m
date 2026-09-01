Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0DE4A13AF
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788295155; cv=pass; b=F3zxPa0nGYJC6V9IKiSNbVYFQAhVnqWwIBKdZtQydxurJrSsmrtPagDZzD7G5/t6nR8z9uM0ZcclFMpxsps9lB8Lxzkj0bp1/1IKfjXQDRFS4KzAMvg33uAH9gzxlUmVeZvjrRhAKo3YmVbdY5zV/4MX1iqvJuyZxq1x0UR67+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788295155; c=relaxed/simple;
	bh=zMXQqnAx/G3j/QNYM2LWpXw58ytOME0jkznw3ohEhIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BeKi/5LriI+mGo127u6TnBFwzXigyDy1nG9nF4+6QskyPQl019mvQ3C+NUDMF3sEtbiQTIW0e26evSvJx9u4yvmwrlOyz3qZywJu/Wf6o5EgcRaJxgPE/EShf55AZysioDC6hc3924chEfNqXYj/Hbxz0FQZYU9VsKCzRkvWtAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KxrvSSNx; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KxrvSSNx"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a60d406a5cso544728a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 13:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788295152; cv=none;
        d=google.com; s=arc-20260327;
        b=HCDjCVSCqFckmmvDKGon2HFjEACr7+Fk8Jk58X/SjE9WRVdt46VIhcooUikVNc9Tvm
         edEILuOVsZByTZihj5Swhe+2VWOZ+2uBFoyopFyrl7x39Am9Y67+VZzNAbiUWQLBL9+l
         1E5FPJSFIvGck1f7Pkf3WJpMzxpvkiRmrWeC3j6NY89GsrWUyTzy6oLgWyZmg3o1T8hR
         f3IRHlRt7N+R3PDjtwNSet9XHrCC1CGi33aMBOWQha/TwFHC/jBh/63fMYnagW5DeYwn
         s2z2WDrkrG1TXWWh2bh6Zibl9mO5Q8ztNVupkhQyzb/R0GVu//RGtUbAu+G5c8aE2Wpt
         2yjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iMSVbAMMClabJnl3yUfS4i27AaasElWu73GA2BM0Mik=;
        fh=WW+Gq8OkQL9qg8ga6AiMElZwoyCzy287JUA8h6DLl2A=;
        b=jbrRX51Bz2u0g6aIZnjUyQwHi3fG8lMGgmI0idxcvNTYj+UzWmHIjoaG/Ce9OH1Us+
         LMWPzxZGdWUvLPLJCGFFHx/TIWYJ86dDhL1xnbdZsbnZyh+ujWc8JFuoX7dF5t2+hy82
         0WPnTYjJMfIzYmmVcp0dFJph5BeCZ0hRfEClLMFUER0/KsQQ4NrnN75gtBxR1+zxhkwr
         ce8JtnYAvI9ypi9aW9HhMDLeIAKdKNL9UlsckzOCb4OtZU4gcsr1eheduMWPXEDCDuD4
         j04rBUi1AuA/Rk0npwW7g/t53SF5XAH8jW7bRfIaUc0j9SKAlGOVyjSdEEgUW8bclhQf
         GY0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788295152; x=1788899952; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iMSVbAMMClabJnl3yUfS4i27AaasElWu73GA2BM0Mik=;
        b=KxrvSSNx4a0vucLe6PhZiunmKB1ppV8M9Wwy+WzJQbelssBPIYCCZyos26/L3b0w+f
         HQFveJHWyRa5J7shqRKrBeleU2D5HwXMaX6wO+3NoaHH2UfvOmGLVaRK7oIv3tl0OhVk
         cDANjOfWYql9g776UmyXreetVyCuJGhECdlkcvBGpu5csMf8TqnmDNeUy/pbTd0Rwk2a
         tPHZiataGNm7fWBv5rhYZ4kB8GK2PHOCLcF1NeixySnBUEnlcYvn29BTsAswrdQGIptm
         unDJE9VI6F0hmyhtQDx2XG1V8T4jkuBOZAixdnhNLHMCvTp0LCQ/9ilEaiRRKYLJTAyV
         SHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788295152; x=1788899952;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iMSVbAMMClabJnl3yUfS4i27AaasElWu73GA2BM0Mik=;
        b=ZglZYjeKU8rA8ZqzZhi6rzbi/izStnaHPdJELJgCpvks973qI8jb7wh+k6hwOgOW/l
         PoQphcqexb/1J43iraOsWv2EevJZ/I/vmy0YhHIKDa/TLLPfuqBj1neL1rNPnaaifUaR
         pn8w/EQaXLrLLrdPe/hSj1YE00oBYEPsZ8OHdqOr1BkhC5/3cU+/dKJAT6zcHokVI4NT
         NQTt86/uAdJ+ExSQBxmCtnZ07PyytfrXe4U8GbrQQZYOOZu6EDt+f6c1o0AA5WubdMOK
         bpY69Y+EFgoTQqJsU+oFj+MOSn5tQJ9+v2X331sdpBejzDM18DBkiQmo2s9lBI6d7+FL
         wUTg==
X-Forwarded-Encrypted: i=1; AKwUvBxp/+CSnZ0oPT7SyPeHD22Uk3ABBLBeukuJ/oNI0BMJX58rSUufOD5kkcOr0n+NMF4y+98tRD4UW8FXVYU=@vger.kernel.org
X-Gm-Message-State: AFuF++mSzku+YUBy618JAiYcSc1RWwoFWG8h3DnJL1sxxDhbmXv9qRS/
	gphnjmT+nRkPZfJpUsjzJ5HcXRW6A+wdTMIe0iSEWARWzgtgq1c/ZZP84+kQ9laoFm5IOGj926A
	wKJ8lE/fA1FUMiPYYzqE9u6KftvRA1rg=
X-Gm-Gg: AYBFou0ntE9N9ko1xD8tvIdaVr9sd07XDOj2NF3YiJ845VMVk0VQnb4xfQM3pbG303I
	vPMKMJzIDvlHLjQyZJz+cun8RVwQG/C8HdtqEtyJn2/VYp6MovYhrPfG3AwAERddD7nUo3QySc0
	t6wfoPWHwoJ60efZskJgm28KnpeErHb3jJFLZwgo60QXL3NEzy25IBL+5ujJ1fqi3g8mPoLLC7y
	ged9sE0Jf8AmeAtRvlm7k+5EhllsBLZ3/vuLbXxYl3IgiBuiUOiBODLyQmpyAG0PTMKHb6ML406
	tkIdkWUfi5TytEnbsSeQj1+iusQ7cI/OswFKp/t3TBoByqfsY2+MOsLr1WwpOdSoCTJL8LBzQvl
	do4+Z5QSZyJRneYGK6L5+hUFTznK1w+dbT4X1WVXmYPohQCF3VMs3bT2fU5ug1p2nLTdU3Ld2vK
	mD8vzEELgmIthVbZ1cFcU4mX+ZN3WkVCwsPbaG1m5prUS3vFQOVHg/cavHexMn9Dw1mA==
X-Received: by 2002:a05:6402:4585:b0:6a6:776f:5859 with SMTP id
 4fb4d7f45d1cf-6a682ac2b12mr255347a12.17.1788295151738; Tue, 01 Sep 2026
 13:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730204722.1101805-1-rosenp@gmail.com> <20260901194524.908240-1-ghidoliemanuele@gmail.com>
In-Reply-To: <20260901194524.908240-1-ghidoliemanuele@gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 1 Sep 2026 13:39:00 -0700
X-Gm-Features: AcwNN1WlvzKl5Ma1R8rX-hNwpVEErP-nMy6eoOGTbH_FUp8tWYaCb1AqEhDSbAA
Message-ID: <CAKxU2N9rW7PpNqUX0w8AR1Doc=LrRPJNct0rYJCTOm3Vskd7Qg@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam: simplify probe resource and IRQ handling
To: Emanuele Ghidoli <ghidoliemanuele@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 12:45=E2=80=AFPM Emanuele Ghidoli
<ghidoliemanuele@gmail.com> wrote:
>
> On Thu, Jul 30, 2026 at 01:47:22PM -0700, Rosen Penev wrote:
> > Replace the open-coded platform_get_resource() plus devm_ioremap()
> > sequence with devm_platform_ioremap_resource(), which fetches the
> > resource, requests the region and maps it in one call.
> >
> > Each fsl,sec-*-job-ring node has a distinct 0x10000 reg region and
> > interrupts property, so the region reservation added by
> > devm_ioremap_resource() is exclusive and does not introduce overlap
> > failures.
>
> This patch, now commit 9a955c0a7d11 in v7.3-rc1, breaks CAAM on most i.MX
> SoCs (i.MX6, i.MX7, i.MX8). All job rings fail to probe and the machine
> loses its hardware RNG:
Sent fix.
>
>   caam_jr 30902000.jr: error -EBUSY: can't request region for resource [m=
em 0x30902000-0x30902fff]
>   caam_jr 30902000.jr: probe with driver caam_jr failed with error -16
>   caam_jr 30903000.jr: error -EBUSY: can't request region for resource [m=
em 0x30903000-0x30903fff]
>   caam_jr 30903000.jr: probe with driver caam_jr failed with error -16
>
> The job rings do not overlap each other, but they all sit inside the reg
> window of their parent fsl,sec-v4.0 node, which caam_probe() already
> reserves exclusively via devm_of_iomap() before it populates the children=
.
> So each job ring now collides with its own parent.
>
> Seen on these boards (CI/CD):
>  - apalis-imx6
>  - apalis-imx8
>  - colibri-imx6
>  - colibri-imx7
>  - colibri-imx8
>  - verdin-imx8mm
>  - verdin-imx8mp
>
> Reverting 9a955c0a7d11 on colibri-imx7 makes the errors disappear.
>
> #regzbot introduced: 9a955c0a7d11
>
> Thanks,
> Emanuele
