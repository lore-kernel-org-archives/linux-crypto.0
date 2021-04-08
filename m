Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6757DC433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 15:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30ED66105A
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 15:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhDHPGQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:06:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231931AbhDHPGP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 11:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617894364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E0p3yL+ASSb4kIMFODsQ6OMg+WKi8voPSOQ8W8M/8ng=;
        b=QbyAKFNfbF1BV/+pYhkvKO0PS60SJjePP4xf528CEDXgb1Ivi9scQZnvbr/GJjP6nBfriY
        aFQWy4PN40lA4Rs3tOmRi42n97399T/CxzXZZet8kZIssEjVRxGYmcdX24VrmSWkaI/Yhc
        qzRcOE8EHuC41C74bj7tZvo6sIANK7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-IwbuC1WfO5CGdjKUhQ1UIg-1; Thu, 08 Apr 2021 11:06:02 -0400
X-MC-Unique: IwbuC1WfO5CGdjKUhQ1UIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75E4D6D581;
        Thu,  8 Apr 2021 15:05:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-119-35.rdu2.redhat.com [10.10.119.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFA2819C66;
        Thu,  8 Apr 2021 15:05:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210408141516.11369-19-varad.gautam@suse.com>
References: <20210408141516.11369-19-varad.gautam@suse.com> <20210408141516.11369-1-varad.gautam@suse.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     dhowells@redhat.com, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net, vt@altlinux.org,
        tianjia.zhang@linux.alibaba.com, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: Re: [PATCH v2 18/18] keyctl_pkey: Add pkey parameters slen and mgfhash for PSS
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12845.1617894354.1@warthog.procyon.org.uk>
Date:   Thu, 08 Apr 2021 16:05:55 +0100
Message-ID: <12846.1617894355@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Varad Gautam <varad.gautam@suse.com> wrote:

> +	Opt_slen,		/* "slen=<salt-length>" eg. "slen=32" */

"slen" seems a bit unobvious.  Maybe "saltlen=..."?

David

