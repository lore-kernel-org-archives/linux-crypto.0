Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A61C433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 15:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B1A6113A
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 15:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhDHPwv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:52:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232080AbhDHPwu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 11:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617897158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9B/sUEO2VShQhd7eWwiUIrKIfr8RV9G7LyCRIKLZBbE=;
        b=NjagCKKS61xqHRHkxYUx1SjD5yX3s9wbujoZFCN8m34GH9NRstPLAkS7mcsmRBbWsEL0Yp
        4uoverPawKybF/FFd2WJIP0HqiuBz3Ja0rIlswYOl3Zbo5rUXr7KeJoG4nGICN96SgU+iD
        D/2nyTsjWC/3Cv86GthZlfCyas+SJSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-X4izMfM0PQeWXMyFdM51gw-1; Thu, 08 Apr 2021 11:52:35 -0400
X-MC-Unique: X4izMfM0PQeWXMyFdM51gw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34065189C440;
        Thu,  8 Apr 2021 15:52:33 +0000 (UTC)
Received: from ovpn-113-96.phx2.redhat.com (ovpn-113-96.phx2.redhat.com [10.3.113.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6748C60864;
        Thu,  8 Apr 2021 15:52:32 +0000 (UTC)
Message-ID: <2a4303680e20e8eac115880c1ac86f39076f0fd7.camel@redhat.com>
Subject: Re: [PATCH v5 1/1] use crc32 instead of md5 for hibernation e820
 integrity check
From:   Simo Sorce <simo@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Chris von Recklinghausen <crecklin@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 08 Apr 2021 11:52:31 -0400
In-Reply-To: <YG8gqZoZGutPmROz@sol.localdomain>
References: <20210408131506.17941-1-crecklin@redhat.com>
         <CAJZ5v0ib+jmbsD9taGW0RujY5c9BCK8yLHv065u44mb0AwO9vQ@mail.gmail.com>
         <YG8gqZoZGutPmROz@sol.localdomain>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-04-08 at 08:26 -0700, Eric Biggers wrote:
> On Thu, Apr 08, 2021 at 03:32:38PM +0200, Rafael J. Wysocki wrote:
> > On Thu, Apr 8, 2021 at 3:15 PM Chris von Recklinghausen
> > <crecklin@redhat.com> wrote:
> > > Suspend fails on a system in fips mode because md5 is used for the e820
> > > integrity check and is not available. Use crc32 instead.
> > > 
> > > This patch changes the integrity check algorithm from md5 to
> > > crc32. This integrity check is used only to verify accidental
> > > corruption of the hybernation data
> > 
> > It isn't used for that.
> > 
> > In fact, it is used to detect differences between the memory map used
> > before hibernation and the one made available by the BIOS during the
> > subsequent resume.  And the check is there, because it is generally
> > unsafe to load the hibernation image into memory if the current memory
> > map doesn't match the one used when the image was created.
> 
> So what types of "differences" are you trying to detect?  If you need to detect
> differences caused by someone who maliciously made changes ("malicious" implies
> they may try to avoid detection), then you need to use a cryptographic hash
> function (or a cryptographic MAC if the hash value isn't stored separately).  If
> you only need to detect non-malicious changes (normally these would be called
> "accidental" changes, but sure, it could be changes that are "intentionally"
> made provided that the other side can be trusted to not try to avoid
> detection...), then a non-cryptographic checksum would be sufficient.

Wouldn't you also need a signature with a TPM key in that case?
An attacker that can change memory maps can also change the hash on
disk ? Unless the hash is in an encrypted partition I guess...

Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




