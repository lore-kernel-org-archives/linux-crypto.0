Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B685C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 13:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343828AbjKAN00 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 09:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344071AbjKAN0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 09:26:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E5D103
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 06:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698845142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5vuuw2hgFSjYMbIsoJnBkA458K2z+JiLRYE0TFB3z/Q=;
        b=FyDwE40id3B+I1StnmclzA7Zb2ect/dG8dNPflteUutQQpIdLIFbVUgftnPdaGqq6TENQg
        IiCllp/pYdKA9nPmyma9PIVoxVRtKBH+TxjAU27Mo/NypaNBSvLTFkJExIh+gKc+ZYDCmO
        GA8HF4r6oojvWFwWxhQ1jDWxKFxHWro=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-9xMMn1IYP0KOZYPpfTEUVQ-1; Wed, 01 Nov 2023 09:25:40 -0400
X-MC-Unique: 9xMMn1IYP0KOZYPpfTEUVQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9a62adedadbso475248166b.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Nov 2023 06:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698845139; x=1699449939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vuuw2hgFSjYMbIsoJnBkA458K2z+JiLRYE0TFB3z/Q=;
        b=A+TTRyHjox4pBFmiNCVB7FmKx5ZDiHk77xgSWnE9vdq4V919jkEMkfKJUwgWSWRWEN
         gnpck/Bhbk1ehSeWGRo39VbOjuN/hhDoU43vzR4njGtfZjc6sUV0IiL3JqjF1zZVrNfq
         +qC3Cxoh10lwqWZ2Chgw/uG//qWOAK03nKRbPS0yNFjNuoIyLHF+U20IWs9HPXM1p9kA
         kJVv+NrrTcaDV6kRZHjWWwh5lKvoOKN/F4kVCbA0Y5uF5IpNhCBUnz1hAEW0fuFU8bsO
         w50QrZNym6Zq3zpYsF2FvkOe4hb65REBMrZ+AG3wlQV8BQZU5mMaF8ESQxqICrNCWInt
         bpHw==
X-Gm-Message-State: AOJu0YwApVrVWyX6l2i26E5pHbgV758MAnNnJYXfyIsw2Ze3qMWHwCIs
        yePkTmHMF7RvbYlWdNOhqm/cwQMlxe2cfEFEpT960cEpkGEdY4zSvx8s/m2PTI8SByq4OINNVSx
        AGh1LCS27xrm/4AH5Lkj9yWJP
X-Received: by 2002:a17:907:da1:b0:9d7:139:ca02 with SMTP id go33-20020a1709070da100b009d70139ca02mr1593789ejc.18.1698845139551;
        Wed, 01 Nov 2023 06:25:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGH01EOmDvR1VZ1Vpqwf7/m2EHCZhBOjFFX6rLdJc7iyoXzWszkpEDc8Iv42M1PCJjd0h1kjg==
X-Received: by 2002:a17:907:da1:b0:9d7:139:ca02 with SMTP id go33-20020a1709070da100b009d70139ca02mr1593777ejc.18.1698845139229;
        Wed, 01 Nov 2023 06:25:39 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f7:e470:9af7:1504:1b35:8a09])
        by smtp.gmail.com with ESMTPSA id cl21-20020a170906c4d500b0099bd1a78ef5sm2397533ejb.74.2023.11.01.06.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 06:25:38 -0700 (PDT)
Date:   Wed, 1 Nov 2023 09:25:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: virtcrypto_dataq_callback calls crypto_finalize_request() from
 irq context
Message-ID: <20231101092521-mutt-send-email-mst@kernel.org>
References: <20230922154546.4f7447ce.pasic@linux.ibm.com>
 <ed47fb73ad634ca395bd6c8e979dda8e@huawei.com>
 <20230924193941.6a02237f.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230924193941.6a02237f.pasic@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 24, 2023 at 07:39:41PM +0200, Halil Pasic wrote:
> On Sun, 24 Sep 2023 11:56:25 +0000
> "Gonglei (Arei)" <arei.gonglei@huawei.com> wrote:
> 
> > Hi Halil,
> > 
> > Commit 4058cf08945 introduced a check for detecting crypto completion function 
> > called with enable BH, and indeed the virtio-crypto driver didn't disable BH, which needs
> > a patch to fix it.
> > 
> > P.S.: https://lore.kernel.org/lkml/20220221120833.2618733-5-clabbe@baylibre.com/T/
> > 
> > Regards,
> > -Gonglei
> 
> Thanks Gonglei!
> 
> Thanks! I would be glad to test that fix on s390x. Are you about to send
> one?
> 
> Regards,
> Halil


Gonglei did you intend to send a fix?

