Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E689C3A59D
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 076FF206C1
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfHPVQV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 17:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbfHPVQU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 17:16:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 924EE3C93;
        Fri, 16 Aug 2019 21:16:20 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9810F12A41;
        Fri, 16 Aug 2019 21:16:16 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] crypto: sha256 - Merge 2 separate C implementations into 1, put into separate library
Date:   Fri, 16 Aug 2019 23:16:05 +0200
Message-Id: <20190816211611.2568-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 16 Aug 2019 21:16:20 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

Here is a patch series refactoring the current 2 separate SHA256
C implementations into 1 and put it into a separate library.

There are 2 reasons for this:

1) Remove the code duplication of having 2 separate implementations

2) Offer a separate library SHA256 implementation which can be used
without having to call crypto_alloc_shash first. This is especially
useful for use during early boot when crypto_alloc_shash does not
work yet.

This has been tested on x86, including checking that kecec still works.

This has NOT been tested on s390, if someone with access to s390 can
test that things still build with this series applied and that
kexec still works, that would be great.

Regards,

Hans

