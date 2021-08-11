Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82BCC4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 10:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DCE760E93
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Aug 2021 10:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbhHKKoE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Aug 2021 06:44:04 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:34795 "EHLO
        mail-0201.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbhHKKoE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Aug 2021 06:44:04 -0400
Date:   Wed, 11 Aug 2021 10:43:01 +0000
Authentication-Results: mail-4316.protonmail.ch; dkim=none
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
From:   David Gstir <david@sigma-star.at>
Cc:     =?utf-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Udit Agarwal <udit.agarwal@nxp.com>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Reply-To: David Gstir <david@sigma-star.at>
Subject: Re: [PATCH 3/4] crypto: caam - add in-kernel interface for blob generator
Message-ID: <85A1078F-B8E1-4E5F-A59A-23BDFB750C83@sigma-star.at>
In-Reply-To: <7cc83edd-dc39-ee7e-d18c-30b2492247ea@pengutronix.de>
References: <cover.9fc9298fd9d63553491871d043a18affc2dbc8a8.1626885907.git-series.a.fatoum@pengutronix.de> <4078060ab2e44114af8204b4defea4f3d4b9e285.1626885907.git-series.a.fatoum@pengutronix.de> <796E18E6-1329-40D6-B12F-4CE6C90DD988@sigma-star.at> <7cc83edd-dc39-ee7e-d18c-30b2492247ea@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ahmad,

> On 11.08.2021, at 12:22, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>
>> Since you already assert that MAX_BLOB_SIZE <= CAAM_BLOB_MAX_LEN
>> in security/keys/trusted-keys/trusted_caam.c, this will never
>> be an issue for CAAM-based trusted-keys though.
> I omitted checks in code, which are verified at compile-time.
> Would you prefer a runtime check to be added as well?

I’d say the compile-time check suffices, unless this is intended
to be used outside of trusted-keys. But I don’t think this is very likely…

Cheers,
David
