Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6049C10F00
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 19:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8419220854
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 19:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfB1TCQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 14:02:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfB1TCQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 14:02:16 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C570308B473;
        Thu, 28 Feb 2019 19:02:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-129.rdu2.redhat.com [10.10.121.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E49211001DF2;
        Thu, 28 Feb 2019 19:02:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190228183923.5klzwli5zmeew54j@altlinux.org>
References: <20190228183923.5klzwli5zmeew54j@altlinux.org> <20190224060828.2527-5-vt@altlinux.org> <20190224060828.2527-1-vt@altlinux.org> <14843.1551377934@warthog.procyon.org.uk>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/10] crypto: akcipher - new verify API for public key algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17532.1551380529.1@warthog.procyon.org.uk>
Date:   Thu, 28 Feb 2019 19:02:09 +0000
Message-ID: <17533.1551380529@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 28 Feb 2019 19:02:16 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

| > It's not clear that sig->digest is guaranteed to be kmalloc memory.

Well, public_key_signature_free() will go bang if it's not kfree'able.

David
