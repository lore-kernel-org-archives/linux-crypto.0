Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5D2C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Mar 2022 22:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiCTWyk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Mar 2022 18:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242936AbiCTWyi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Mar 2022 18:54:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7CE1369EC
        for <linux-crypto@vger.kernel.org>; Sun, 20 Mar 2022 15:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647816790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lbklHsC4p2zDoA9Qm45sY9QvlkWdqqX9EtVTWkPxbLA=;
        b=TcNXjRqi/sMoz/p1eroeIlV8om0e909RmQme1L3vYD7ftn0dINAU/ouGFmIeBdqHCCsFGE
        VRsaV8Es6s2PXM/n2gSWTdphJNFWqBzZnxYmVQzF2YHJrPAij4lVc29ibYl48xVMmUj8KD
        CR2+/7q3Kna6eC9g0vB/Mh5GSrxWL9E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-1GwdQgH3Mhy6YhwYcxglBg-1; Sun, 20 Mar 2022 18:53:08 -0400
X-MC-Unique: 1GwdQgH3Mhy6YhwYcxglBg-1
Received: by mail-ej1-f69.google.com with SMTP id 13-20020a170906328d00b006982d0888a4so6254687ejw.9
        for <linux-crypto@vger.kernel.org>; Sun, 20 Mar 2022 15:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lbklHsC4p2zDoA9Qm45sY9QvlkWdqqX9EtVTWkPxbLA=;
        b=3U26IG7B8PjAgYqNBx87ABpdjfPve73ar3q9Yt56Ie5eKDcQsCknyGl22W2/FvPXs+
         yEyfgDKRanZD8uRkNSYAAnUdgA6Stet+qgtp5pAJjMe6yEl0N/KZ6utTx40oSVslrrOp
         M7bSa9jAHT/2a1jhdqxlpXtJdGhskg/OivLZ7854enBdAZhjbfXvZMpqWeSgln5oQQwf
         emTRsx+460R0AekPHRInjk6i4NNYbq8F91iBJv/tIy0WZhhDMGrvOLLdZD0Hk4fHO3qG
         ZOtpg/U83VcoWw7RJSDCLtNr8QmjIMOQjoqT2rrSqfauiDJn6Yse0JHETCtSreygp9II
         n4fg==
X-Gm-Message-State: AOAM530nbo0p8RmFiLAXWJJkbstIZC+NQ8rs2g3SmuY6+XAcCR63OnsR
        nWQ/bTBlJPrPtxlVErwVssmwumfm/h2R2CTKZWsKNQHS792FPITt79wWvIFzT+XH+uw8tHGwkcA
        pCxSVVPNfxKevrS/mErhBVkq4
X-Received: by 2002:a17:907:7287:b0:6df:8f48:3f76 with SMTP id dt7-20020a170907728700b006df8f483f76mr17022713ejc.411.1647816787613;
        Sun, 20 Mar 2022 15:53:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZe9l6Up1iG5LURVWCj/AihbE5iv/oi8hjD6mxD1AXkSiAxFIFKMfPOvm35kPXKaxucLH/AQ==
X-Received: by 2002:a17:907:7287:b0:6df:8f48:3f76 with SMTP id dt7-20020a170907728700b006df8f483f76mr17022701ejc.411.1647816787435;
        Sun, 20 Mar 2022 15:53:07 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm6300968ejj.74.2022.03.20.15.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 15:53:06 -0700 (PDT)
Date:   Sun, 20 Mar 2022 18:53:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        linux-hyperv@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        adrian@parity.io, Laszlo Ersek <lersek@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linux PM <linux-pm@vger.kernel.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: propagating vmgenid outward and upward
Message-ID: <20220320185049-mutt-send-email-mst@kernel.org>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
 <c5181fb5-38fb-f261-9de5-24655be1c749@amazon.com>
 <CAHmME9rTMDkE7UA3_wg87mrDVYps+YaHw+dZwF0EbM0zC4pQQw@mail.gmail.com>
 <47137806-9162-0f60-e830-1a3731595c8c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47137806-9162-0f60-e830-1a3731595c8c@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 10, 2022 at 12:18:04PM +0100, Alexander Graf wrote:
> I agree on the slightly racy compromise

Thought hard about this, I think I agree, and I guess as a minimum we
can start with at least the ACPI+RNG patch, right? That will already
address wireguard ...

-- 
MST

