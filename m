From: Fabio Estevam <festevam@gmail.com>
Subject: mxs-dcp: Failed to register sha1 hash
Date: Thu, 26 Nov 2015 13:14:12 -0200
Message-ID: <CAOMZO5AyAAfZM07KYHCfRaeia8Ut1F6s=jsFg6C3YYzHx8C5UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33977 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbKZPOM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 10:14:12 -0500
Received: by igvg19 with SMTP id g19so16276154igv.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2015 07:14:12 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On kernel 4.1.13 and also on 4.4.0-rc2-next-20151126 I see the
following error on mx28:

[    2.245453] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
[    2.253928] mxs-dcp: probe of 80028000.dcp failed with error -22

Does anyone have any idea how to fix this?

Thanks,

Fabio Estevam
