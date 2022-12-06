Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BF4C3A5A7
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 09:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiLFI77 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 03:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbiLFI76 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 03:59:58 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4801D0F0
        for <linux-crypto@vger.kernel.org>; Tue,  6 Dec 2022 00:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1670317190; bh=5XPl1ihXN6xQ6b3jFPXWFdMdjAEy0aAHItOv+OfgLrg=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=K3ZhFwB/ahesFHIDHngsmim6+dfxNDjpkUEXzJKRRJuvwey8EpCfDzmMAwOtQZ/wA
         EOXR+QK0wgWmheyjqDKduOe24FTw3NzlA6iRJjVJzH5VbIFFV6+hwHRC7XR3FSRvtV
         TxCrtSsHwzt2ZWDrUuOQzLzw66Y+AWzj8PuF0pmQqwclDXejUIGICe/gbtwIoIKpAJ
         mw64E6tu77/44u+1A5PKP4+PNu9C59vnIKNW/RvY1720naxhbxVPo9zqz+hJ1ZUNq1
         1yX7TCCxgnYVLn4shMnUWoCK/4BP3K+4rzWJB6Q6+mb/uvK5YA2xQ1EIn6kW2aSEQG
         16sxEiHFo1pRw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [10.0.2.15] ([94.31.87.22]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MYvY2-1pXOli1beq-00UpVv; Tue, 06
 Dec 2022 09:59:50 +0100
Message-ID: <c5fcd63053fb117582fc8788e276fa5d6ffd3e78.camel@gmx.de>
Subject: Re: [PATCH 0/6] crypto/realtek: add new driver
From:   Markus Stockhausen <markus.stockhausen@gmx.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Date:   Tue, 06 Dec 2022 09:59:49 +0100
In-Reply-To: <Y47AycWFkn48EvL5@gondor.apana.org.au>
References: <20221013184026.63826-1-markus.stockhausen@gmx.de>
         <fe7800282ff11f7822778eb9109864f1f3b144f2.camel@gmx.de>
         <Y47AycWFkn48EvL5@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-Provags-ID: V03:K1:MjvBCBZBtVUjBCRC/DwyKqh3747SNjuFNCOq1gpAPgc00JCB/4e
 UpK+GshqDIHmEGj8rzjfdoJnJJTT/oUMJWGhE0XUyPfmZK2ZsiuGqWgP0+HGks0GWBANA72
 my40B1j9Ip7mskoCaNCgFVPm2Naaa8YPOF28qNlC6ZFbfAcAshEcVV8xYoue2cTWnzweuqv
 zUXxgODALFJccsJxVarmg==
UI-OutboundReport: notjunk:1;M01:P0:6dYnmstFxE8=;EO2BHFZCqvBhjyNFAjL+9OKLzTR
 vBgma9wVqdfMswR9pYxJhScl4+7+VVxInddbzh+n1hTjjTvzLDOFRXOcZztES5bSPxNn9NkzB
 pFybsFiIoBWu9f0oX5UCx62h0CInnB+PSNW9HLm25OlTN9MckLC8dk+uzphtO3Wy0Y4sboufW
 v5SMKm55aRDD1kfqG+n6W3g8FQiWlm6CGRRw1P3R+FYJ+GTIZq4hFv85gpXXAI9AO5IB4Hg4W
 X/uaNJFjWh1sHd9MDnbEFEFq8+BNXmiJfo6CwIq8D2krMtjQy4yc7k+Nz5VDWMoFItPcOv4ww
 g4VHdtthPXjmsww1+SliCmFZBMyvvJRYYbqdQk7clmP5Q86rD8f/39PDEHPrZLPfADR6tqoLO
 GGDQLBB3gdNmh8Jbel/GjOusU06N6oM4PjEr9b8DPKqaIo7vu7g87yetkI7mbtJcb+OS6A8Ig
 82Km5l5DTakayWRHKyeWrzIKmDYCNHaD/FQXLKBQOgwCAF1+4VIczVtkC6J4DaV1yPZGhOyet
 ewTYSj1UV5wQlI6gSHr9JeidKv+3tyaiSgxcDEnwPYwu4Z+TBpk05xzgDBSvtX8lAxOqosF+T
 A/EP1msI4X4GJjONUDFW/j+YFI8OrVglgecHAaDbf5bM+n/b3imWNZ7VGvlzfLq44leEwOcR0
 i4mvgRMLYI31PFz7j3jYMCz7LFcwu9E4hGhHkTbT3fX4M4nsE6PhLx3et+Ow2mNXTCegcK7br
 k+ose5+cmSS4UztBBsQ/muZYEumx2VE+iGYekvvnHC2xphpMdv94LLC5yFb/tA3ePyu8AGk1q
 0Iz5p9P4qp0+5YuULq8J1vH+3wzrDDCFVnmvRY42BZluwpBgzJUPR94ihXRLhC2eJ/WUgjqaJ
 d+aSnEHBmWyyASQENJsrYBDkuDeniMg0JPXdHCjf0GG+4IcKMDInsb8+tqWpX7x51zL90F+3p
 v3Izzw==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, dem 06.12.2022 um 12:10 +0800 schrieb Herbert Xu:
> On Mon, Dec 05, 2022 at 07:47:59PM +0100, Markus Stockhausen wrote:
> >=20
> > as I got neither positive nor negative feedback after your last
> > question I just want to ask if there is any work for me to do on
> > this
> > series?
>=20
> Sorry about that.
>=20
> There is still an issue with your import function.=C2=A0 You dereference
> the imported state directly.=C2=A0 That is not allowed because there is
> no guarantee that the imported state is aligned for a direct CPU
> load.
>=20
> So you'll either need to copy it somewhere first or use an unaligned
> load to access hexp->state.
>=20
> Cheers,

No problem,

this is something I can work with. Nevertheless I'm unsure about your
guidance. If I get it right, the state assignment is not ok.

	...
	const struct rtcr_ahash_req *hexp =3D in;

	hreq->state =3D hexp->state; << *** maybe unaligned? ***
	if (hreq->state & RTCR_REQ_FB_ACT)
		hreq->state |=3D RTCR_REQ_FB_RDY;

	if (rtcr_check_fallback(areq))
		return crypto_ahash_import(freq, fexp);

	memcpy(hreq, hexp, sizeof(struct rtcr_ahash_req));
	...

Comparing this to safeexcel_ahash_import() where I got my ideas from
one sees a similar coding:

	...
	const struct safexcel_ahash_export_state *export =3D in;
	int ret;

	ret =3D crypto_ahash_init(areq);
	if (ret)
		return ret;

	req->len =3D export->len; << *** same here ***
	req->processed =3D export->processed;

	req->digest =3D export->digest;

	memcpy(req->cache, export->cache, HASH_CACHE_SIZE);
	memcpy(req->state, export->state, req->state_sz);
	...

Thanks in advance for your help.

