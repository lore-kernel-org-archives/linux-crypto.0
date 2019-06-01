Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE6FC28CC3
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 19:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 599C9276E4
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 19:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.ca header.i=@yahoo.ca header.b="GFA5BRaZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFATlz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 15:41:55 -0400
Received: from sonic301-32.consmr.mail.ne1.yahoo.com ([66.163.184.201]:35159
        "EHLO sonic301-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbfFATlz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 15:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.ca; s=s2048; t=1559418113; bh=8713HDhZQya8lWL0W8on0YNF6KO3UUWiPnP3Vn4P6BY=; h=In-Reply-To:References:From:To:Subject:Cc:Date:From:Subject; b=GFA5BRaZS7PRtFd7nonAMq4kR7+7/w2QpZH78/Pe3hX69+0qZLmX7WxMe2FYEX1Wj9qrYFEACuNZxHZ1hv16HyrtVsWYmGOLHcaSK8BxeBEY6AQHapbnoOJH7TuWN60jaRyzqbWlrO8XwsPDvleNotXDzTcMacq0hlODLbzk8zhz5hYSRRTC54qafh0Z4a6YzmuGzyBxZh+Rbcqq9ZTi6cIHghIwFLpioPQOBE6MzkTeNIEVLZXNRRMnl+6hDkPI5niEUWqFgEslN6IG3Xv1loIVgNIHjR+t0reRS4AZOT7/5OUbvMR+tPcj3sLyAUs27PNgGEQYuMKfHOAL816XCw==
X-YMail-OSG: .a2GnfkVM1mK2E8krSQEMNfHekcUf4o375_xIZWuscuNwaoqll3Awqj9IQDLLp1
 yHVchtvuAQen0GgcI1GEyCNBLiCdgR3jhgA5djPNM3eWMnptVEDzyZW35gESHjp2Tjh2JT5V1EEm
 CPlmrOSZ4NUaxOQbCSBNtQQLk8PctDYjm7Lbv4zdSkpaNopJbzLlnLqzOF5VXaar3TdxHF3bhk6W
 tLQwBOu4DdfTNCBy4wK4UH9Q.TEtx4WUHPH7_DdYbMX6eLjry3T3_eTlUvEVxSwH5VKDVxkYbI8P
 MkszG08wlTANi7motOU8S14pt1ZOlYkdDVRIFGneI6DrCr7YcxsDxTa723x5HPIVultJugc3ZbXy
 h5ECGfi1cACmHilkZtFDGZCcWe_PAO8ilaqqhpTY1F7jwS6e5AtN3tghfw_CIlTmesWq1klGNqSs
 C7ofvy57qnUgCuPciXyfdH.s24sCSUFzGNSL6rpXk94PKL2aAcCXuXJScd30Kod.wss5rki9ueE.
 vSj7ZsZkrvW6WJSsGH.nln_YdyuRlu0W_6WuEMyxGcEzhcL743R2lEXgSBMOzOdPxejJGXj8zlYx
 JdMH0Za_2DnuozOA6sShcBWhL_UjLH76B22sSuNSSgjpj21q6ksmoVFkz3Ia.WO52Hu6jaGWm2u0
 pDaZx016danD.fSFCth_wi3EvTdnmF4X3nnA87L4kM0hyOpaO1LLClWKIFfw_qdF84uQIERC4K6M
 OLixyoZmgJ.IqhVqesWK_l5N0qXyAtKHF3TZR8gUz8FiLSRMSvzRpEfW1vwD_dIUUttyrlwhq49z
 jdJEnlh2yXEtK7cMDaIbbfDLTAOqy6KZPCCp6uebFoSJsg6xBNaDWv6vQwILSVbQjbs13QlG_vXi
 oJxaAqYn7zgdWRrSuRnYTumKbezPCJi2h0RWkPsCkJrwd_JyrHk_XCAB_U3fjL989VHJCYimoHRK
 O16wHQ42DGEySX272wmu4ok835AO5ZpA8ANQdXV0tLweY_HTt0MZwVEt94_tOhc1zFEuRyWIOt4B
 nMSbDCNIxMLwhiuELD.cLjZ3LFrWWJn.rhgXy93cqKmIK02WTr30F7RgGQKhrIr4c4.x59XtuSdB
 iEYce0G3FhyGnbg5M1eAHBT770MthTpNNsN8APXTfbMFAIONZTme__U2grr9eTC13Rh3OkOqg41Y
 rdy7FHUEkgecHjwYFnKuYozSHKD4aIvzf2L4PV2ZF9JTOrHVPSjfO4t7ftE1PPHk-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Sat, 1 Jun 2019 19:41:53 +0000
Received: from pink.alxu.ca (EHLO localhost) ([198.98.62.56])
          by smtp406.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID f5d5a22d1a321ea646c829e6229e0c9d;
          Sat, 01 Jun 2019 19:41:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190601162907.GB6261@kroah.com>
References: <20190601144943.126995-1-alex_y_xu@yahoo.ca> <20190601162907.GB6261@kroah.com>
From:   Alex Xu <alex_y_xu@yahoo.ca>
To:     Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: ux500 - fix license comment syntax error
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, allison@lohutok.net, alexios.zavras@intel.com,
        swinslow@gmail.com, rfontana@redhat.com,
        linux-spdx@vger.kernel.org, torvalds@linux-foundation.org
Message-ID: <155941810155.1991.11907646865432946934@pink.alxu.ca>
User-Agent: alot/0.8.1
Date:   Sat, 01 Jun 2019 19:41:41 +0000
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Greg KH (2019-06-01 16:29:07)
> On Sat, Jun 01, 2019 at 10:49:43AM -0400, Alex Xu (Hello71) wrote:
> > Causes error: drivers/crypto/ux500/cryp/Makefile:5: *** missing
> > separator.  Stop.
> >=20
> > Fixes: af873fcecef5 ("treewide: Replace GPLv2 boilerplate/reference wit=
h SPDX - rule 194")
> > Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
> > ---
> >  drivers/crypto/ux500/cryp/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Also, how did 0-day not catch this?  Is this an odd configuration that
> it can not build?

I had to run "make clean" to get the error.
