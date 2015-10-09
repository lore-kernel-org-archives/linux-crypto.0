From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 0/3] hwrng: st: Couple of improvements
Date: Fri, 9 Oct 2015 08:24:24 +0100
Message-ID: <20151009072424.GM17172@x1>
References: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
 <20151008142340.GD25166@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel@stlinux.com, linux-crypto@vger.kernel.org,
	pankaj.dev@st.com, daniel.thompson@linaro.org,
	linux@arm.linux.org.uk
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33428 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbbJIHY3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 03:24:29 -0400
Received: by wiclk2 with SMTP id lk2so58033370wic.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Oct 2015 00:24:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151008142340.GD25166@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 08 Oct 2015, Herbert Xu wrote:

> On Wed, Oct 07, 2015 at 01:23:26PM +0100, Lee Jones wrote:
> > This set contains a minor documentation fix, greater clarification
> > with how the FIFO depth/size is represented and finally a fix to
> > prevent early timeout during data acquisition.
> >=20
> > v1 =3D> v2:
> >  - Remove phantom bugfix (FIFO really is 4 deep, not 8)
> >  - Double timeout value to account for inconsistent call to udelay(=
)
> >    - Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>
>=20
> All applied.  Thanks.

Thanks Herbert.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
