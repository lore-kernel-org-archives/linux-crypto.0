Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75296C07E9B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 10:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58152610D2
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 10:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhGSJWC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 05:22:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235172AbhGSJWC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 05:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626688962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LIArJd668+DITQakrkSuaSzmxBEQaYwP9nAIeL820XM=;
        b=OviGc9ExzUopEFKYfBIZx4b41OLkTF7KZLZiTg8ucavtLi6poq1VGoOJGw17yIv8SdtsxH
        OK0DpX0r6JWTX+oblAr6HQXAt9UbvWynUc+eJRq4IbO8LuqwlF8pTt0la1928msaTG6OCA
        vPzqGSi4MmwP+GtwEwzPJiRBibw/qbU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-S858lTQ9NpSqnk6rNdUH6g-1; Mon, 19 Jul 2021 06:02:40 -0400
X-MC-Unique: S858lTQ9NpSqnk6rNdUH6g-1
Received: by mail-ej1-f71.google.com with SMTP id r10-20020a170906350ab02904f12f4a8c69so5170959eja.12
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 03:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=LIArJd668+DITQakrkSuaSzmxBEQaYwP9nAIeL820XM=;
        b=ZpOB/GKdu7Dxz8jaf91TSIjWCaROhoyYX4GBVQSJ/tsBjiZyD+YAUYvUwuIFEI074h
         4trXHV4s8bgSZI2ItYBr7VG5O5puy43F27ocxsMv91An5Kd4m8wd+D8mrK9PvgNz/tBz
         c5vqchz0jDotPLwSdSs99YtMXDmruQRg/Wp2yuJ7aX2QwUKwTpzYjkt9Us27zSyf6KLH
         QvRkUKrxO1a0Wh3eCBXBIoSqFYsB6W41I0INnm0u9HVsAN8VHZ47L/TQfG71bOBIkhL0
         76ck1TUIRWkDQ0ui3oD+1u0Lb/B32GvTUAm3tN9/hSpWfazHzNVtL4hW/FKXfH6L15Xq
         +g7A==
X-Gm-Message-State: AOAM532Hi3ql4OdsMj+TdAzFjq59WXWEF2pvjioZDua8JptH1mDenRyS
        IMYUA0t/Zo5eMFRkW6cGUIOz2zVzkA1f3+VNd2hAH/A2H6gUsbnVOT4iKEadrpgSHWFj6TrPJ0K
        /B/PuY+VC4TUkFh4WiqJjKL0O
X-Received: by 2002:a05:6402:22c6:: with SMTP id dm6mr33660107edb.228.1626688959519;
        Mon, 19 Jul 2021 03:02:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf7AlHivCiHIxTEU+yzlNocceBxfAEdg+F908CY6q9MgpA1ztNfyNzGn8lRI1RGkddChsXfw==
X-Received: by 2002:a05:6402:22c6:: with SMTP id dm6mr33660085edb.228.1626688959306;
        Mon, 19 Jul 2021 03:02:39 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([93.56.160.10])
        by smtp.gmail.com with ESMTPSA id d3sm7602270edp.11.2021.07.19.03.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 03:02:38 -0700 (PDT)
Message-ID: <fce7efe2a5f1047e9f4ab93eedf5ace1946d308c.camel@redhat.com>
Subject: Re: [RFC PATCH 00/11] nvme: In-band authentication support
From:   Simo Sorce <simo@redhat.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Date:   Mon, 19 Jul 2021 06:02:38 -0400
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 2021-07-16 at 13:04 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> recent updates to the NVMe spec have added definitions for in-band
> authentication, and seeing that it provides some real benefit especially
> for NVMe-TCP here's an attempt to implement it.
> 
> Tricky bit here is that the specification orients itself on TLS 1.3,
> but supports only the FFDHE groups. Which of course the kernel doesn't
> support. I've been able to come up with a patch for this, but as this
> is my first attempt to fix anything in the crypto area I would invite
> people more familiar with these matters to have a look.
> 
> Also note that this is just for in-band authentication. Secure concatenation
> (ie starting TLS with the negotiated parameters) is not implemented; one would
> need to update the kernel TLS implementation for this, which at this time is
> beyond scope.
> 
> As usual, comments and reviews are welcome.

Hi Hannes,
could you please reference the specific standards that describe the
NVMe authentication protocols?

Thanks,
Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




