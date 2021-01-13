Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAA2C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 19:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 619AF23102
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 19:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbhAMTZY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 14:25:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728325AbhAMTZY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 14:25:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610565838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HcC8AUhgxB2nKsEbFplqxs+UaFp2Qy31anNGiuGduMU=;
        b=XH0xKAlycJpH7Z+C/HfFGNTbpI83GORr31M9UqqZJ4Ow3e/H7rrcAcbzSrmyAkJXhHXN9C
        scrVBmCR/zFs7mIv6rhbUP2bPvCEUK6nxGhvmjMgmaVpP+NRLPSuNRnQPUYvbzlAMJjqSU
        JDuYVxCO+IQxlGCQrUjsj08RL77lh7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-AHAiIQ4VPOmJHO8dvXQUzg-1; Wed, 13 Jan 2021 14:23:56 -0500
X-MC-Unique: AHAiIQ4VPOmJHO8dvXQUzg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3114D107ACF7;
        Wed, 13 Jan 2021 19:23:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF1810023B3;
        Wed, 13 Jan 2021 19:23:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <2660556.1610545213@warthog.procyon.org.uk>
References: <2660556.1610545213@warthog.procyon.org.uk>
To:     torvalds@linux-foundation.org
Cc:     dhowells@redhat.com, jarkko@kernel.org, eric.snowberg@oracle.com,
        ard.biesheuvel@linaro.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] certs: Add EFI_CERT_X509_GUID support for dbx entries
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2688930.1610565830.1@warthog.procyon.org.uk>
Date:   Wed, 13 Jan 2021 19:23:50 +0000
Message-ID: <2688931.1610565830@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

>     This fixes CVE-2020-26541.

Note that I added the CVE number, not Eric.

David

