Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62990C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Nov 2022 13:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiKDNV7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Nov 2022 09:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiKDNVx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2022 09:21:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE70327CCD
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 06:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667568058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=4z+uaTyHS1euo8ITS5ujuXPAETlqQ178964oXSUna1g=;
        b=hGd8pylCeh0mGbZZWCiLN4JbsVkueKhNa7k1o67opB0XAJ9C6s3vZDzLRojj3ufxKf7UXE
        lW3kevGaxfDKSPzUr8tSsRhx30Ushk/hYVs7NGLEAEKnsYpQ6g6CLGUSuNA4dbjwwrYUfT
        P1dgEvzYsPHj/KohGztIxfqr2fuh2+k=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-azmzIxivMAuf-tphlkitKw-1; Fri, 04 Nov 2022 09:20:57 -0400
X-MC-Unique: azmzIxivMAuf-tphlkitKw-1
Received: by mail-pl1-f200.google.com with SMTP id b2-20020a170902d50200b001871a3c51afso3554730plg.8
        for <linux-crypto@vger.kernel.org>; Fri, 04 Nov 2022 06:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4z+uaTyHS1euo8ITS5ujuXPAETlqQ178964oXSUna1g=;
        b=Qmj0hZgPF1SmkngtCOZL0NUizm1I2wrtkQXgyGUcLhMh2NEYJS7ybSLO1q0oESGZ7T
         yBb+wRvUg4c3wWTUGYXutFS232TdjUaBh+/gU6X7tEep/3eNRGEbz8hRocoO+zIoQasy
         glCwt8aKM+j0El4H9uqX2P70tjtrO7obvurke0YyqeSHOeYtkQDNNbYMgoiUMushPQM9
         POPAg1+vCP99lB/ZoRW7uvibz1OSSpL8FoD9hGNWIVi5CzhcLhZ0OFACvl/cWbMK9NHS
         Mj1Q6Pn4MbRPMnNwU93ATxhDC26uS6Dz2gH7hblpc+PZWlxKBllHIWehoTAVeXhFFA7c
         LXAA==
X-Gm-Message-State: ACrzQf2mNZBi9ujGuJbKzpqeVEHan8aNEYCMT60LRH4btHFZSdRITcXl
        z84yvvU29HSc5fa0ss4V63AcLRWQjxLDbw3apxhDs52IO+IAePfdoc+QGIOjuBe/QZY6higRu/N
        Xqz5r9C7Vccobpbx59wf87Z+G
X-Received: by 2002:a17:902:e8d4:b0:177:e4c7:e8b7 with SMTP id v20-20020a170902e8d400b00177e4c7e8b7mr329607plg.118.1667568056600;
        Fri, 04 Nov 2022 06:20:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6XbTeqtZliMwzZ7MGO3ejsjE4fdEnYbMsIkDBmckaWvRU+DhCnC80HUipTcPjnE/pSnZOacw==
X-Received: by 2002:a17:902:e8d4:b0:177:e4c7:e8b7 with SMTP id v20-20020a170902e8d400b00177e4c7e8b7mr329594plg.118.1667568056353;
        Fri, 04 Nov 2022 06:20:56 -0700 (PDT)
Received: from localhost ([240e:479:210:84fd:b8ac:1631:3300:5ef])
        by smtp.gmail.com with ESMTPSA id iw17-20020a170903045100b001780e4e6b65sm2597596plb.114.2022.11.04.06.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 06:20:55 -0700 (PDT)
Date:   Fri, 4 Nov 2022 21:20:35 +0800
From:   Coiby Xu <coxu@redhat.com>
To:     eric.snowberg@oracle.com
Cc:     davem@davemloft.net, dhowells@redhat.com,
        dmitry.kasatkin@gmail.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, jarkko@kernel.org, jmorris@namei.org,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, nramas@linux.microsoft.com,
        pvorel@suse.cz, roberto.sassu@huawei.com, serge@hallyn.com,
        tiwai@suse.de, zohar@linux.ibm.com
Subject: Re: [PATCH 0/7] Add CA enforcement keyring restrictions
Message-ID: <20221104132035.rmavewmeo6ceyjou@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220406015337.4000739-1-eric.snowberg@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

I wonder if there is any update on this work? I would be glad to do
anything that may be helpful including testing a new version of code.

-- 
Best regards,
Coiby

