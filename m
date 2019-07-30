Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB44C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86B7220693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfG3Mii (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfG3Mii (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:38:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E9A081F0F;
        Tue, 30 Jul 2019 12:38:38 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 051C85D6A7;
        Tue, 30 Jul 2019 12:38:36 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: [RFC 0/3] Making a secure hash function avaiable during early boot?
Date:   Tue, 30 Jul 2019 14:38:32 +0200
Message-Id: <20190730123835.10283-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 30 Jul 2019 12:38:38 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

During the first half of 2018 I wrote a patch series to the Linux EFI
and firmware-loader code, which allows loading peripheral firmware
which is embedded/hidden inside the EFI firmware through the standard
firmware-loading mechanism.

The main motivation for this is to get the touchscreen to work OOTB
on various cheap x86 tablets which come with a touchscreen controller
which need to have device(model)-specific firmware loaded; and we have
been unable to acquire permission to re-distribute this firmware-s
in linux-firmware.

This patch series works by extending the per model touchscreen data which
we already built into the kernel in drivers/platform/x86/touchscreen_dmi.c
with some extra info: a 8 byte header to search for, the lenght of the
firmware image and a the expected hash of the firmware for that model.

During boot, after setting up memory management (so that kmalloc work)
and before calling all the various init functions such as subsys_init calls
from rest_init, the EFI code does a DMI check and if the system in question
is in the list of systems with EFI embedded fw which we want i tgoes over
all EFI_BOOT_SERVICES_CODE sections searching for the described firmware.

After 6 revisions this series stalled on the lack of a hash algorithm which
can be used during early boot.

The plan was to wait for the zinc crypto code to get used and use a hash
algorithm from that, but that still has not happened, which is my main
reason for sending out this email.

For the last couple of revisions of the patch set I've been using a set
of patches by Andy Lutomirski which make the sha256-generic code usable
without calling crypto_alloc_shash() etc. Using crypto_alloc_shash() is
not possible because that depends on crypto_register_shash having been
called which is done as a subsys_initcall() and thus too late.

I cannot move the efi_check_for_embedded_firmwares() call later for 2
reasons:
1) Some of the subsys_init calls may rely on some of the embedded firmwares
2) It needs to be one before efi_free_boot_services() gets called, which is
not something which can safely / easily be moved to a later stage.

So my question is, would it be possible for the patches from Andy (which
I'm sending together with this email) to get merged so that there is a
generic secure hash available before subsys_initcall() time; or do you
(the crypto maintainers) have any other idea how to solve this?

Note I'm open to changing to a different hash function, the hashes are
embedded into drivers/platform/x86/touchscreen_dmi.c and I've access to
dumps of all firmwares for which I want to initially add support so I
can calculate another hash for the files.

Regards,

Hans


