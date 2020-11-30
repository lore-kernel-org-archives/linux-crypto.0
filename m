Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36715C64E8A
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 09:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C23A7207BC
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 09:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c15twNxR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgK3JLW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 04:11:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgK3JLW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 04:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606727396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EoMMNm0IUt1GO2xD2OU0HZdE8ALUJkd8oHe2thJ9cwY=;
        b=c15twNxRD7Ul87aJBnNjnEPXjS1LcbSjSRdHAxGKzIXIUMyWSx6WjtZbHndzatyg+vqp7V
        4KtvxjaRYc+sYGKeJImLFrsbsmGWoCjrOWf9JRK0eVyR6cCyv5z+A2f76BGVMhm4cHDmbp
        nJSL0t7guKxZ7rHABSytAy6gclir7uI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-6yb7Kk_GMOOYXJT19jeF_Q-1; Mon, 30 Nov 2020 04:09:51 -0500
X-MC-Unique: 6yb7Kk_GMOOYXJT19jeF_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57D15873110;
        Mon, 30 Nov 2020 09:09:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-159.rdu2.redhat.com [10.10.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA24160843;
        Mon, 30 Nov 2020 09:09:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <67250277-7903-2005-b94b-193bce0a3388@markus-regensburg.de>
References: <67250277-7903-2005-b94b-193bce0a3388@markus-regensburg.de>
To:     Tobias Markus <tobias@markus-regensburg.de>
Cc:     dhowells@redhat.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org
Subject: Re: Null pointer dereference in public key verification (related to SM2 introduction)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3092219.1606727387.1@warthog.procyon.org.uk>
Date:   Mon, 30 Nov 2020 09:09:47 +0000
Message-ID: <3092220.1606727387@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tobias Markus <tobias@markus-regensburg.de> wrote:

> kernel: RIP: 0010:public_key_verify_signature+0x189/0x3f0

Is it possible for you to provide a disassembly of this function from the
kernel you were using?  For this to occur on that line, it appears that sig
would need to be NULL - but that should trip an assertion at the top of the
function - or a very small number (which could be RCX, R09 or R11).

Thanks,
David

