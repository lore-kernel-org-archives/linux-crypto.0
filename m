Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D8AC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 17:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22738207DA
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591033268;
	bh=egFH6RgQ4a+4kLCfGrEDkjv5v4bJblqDQOjodPikqEM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:List-ID:From;
	b=RIVmAK75cmgDVIrimRB4BmGk7O3SbS66iMPw95FcvdSsiFbgce8lJvgvInAPlHv6L
	 +d8otOMUxlhOJQxpyzWtZCy1E3Q+tE53fvSpNXFo7BPEStCeTPzz233fx4dg4TmQgN
	 OAm5+zLvsCLAX58/mq16QKb92HPBUMQP0NTVSkjc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgFARlH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 13:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFARlH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 13:41:07 -0400
Received: from localhost (mobile-166-175-190-200.mycingular.net [166.175.190.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FEF206A4;
        Mon,  1 Jun 2020 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591033266;
        bh=egFH6RgQ4a+4kLCfGrEDkjv5v4bJblqDQOjodPikqEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=PBS/XvI5mPBJhMQPW3QR/267YghZh8VBNHFVIA3y76nvmv7wSAOnIG8ZofBmrwL3W
         hjX/e/kbh6hI/0SHMT/KsCJ3IYwK/78zwY6ZY8W6ZDDtNYI4kfbVVgq5NF84Mj/Dz5
         u9OiYWmcq6uvLgae6Udy20G6q8HsslAkBraLQcZo=
Date:   Mon, 1 Jun 2020 12:41:04 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        jean-philippe <jean-philippe@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/2] Introduce PCI_FIXUP_IOMMU
Message-ID: <20200601174104.GA734973@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528073344.GO5221@8bytes.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 28, 2020 at 09:33:44AM +0200, Joerg Roedel wrote:
> On Wed, May 27, 2020 at 01:18:42PM -0500, Bjorn Helgaas wrote:
> > Is this slowdown significant?  We already iterate over every device
> > when applying PCI_FIXUP_FINAL quirks, so if we used the existing
> > PCI_FIXUP_FINAL, we wouldn't be adding a new loop.  We would only be
> > adding two more iterations to the loop in pci_do_fixups() that tries
> > to match quirks against the current device.  I doubt that would be a
> > measurable slowdown.
> 
> I don't know how significant it is, but I remember people complaining
> about adding new PCI quirks because it takes too long for them to run
> them all. That was in the discussion about the quirk disabling ATS on
> AMD Stoney systems.
> 
> So it probably depends on how many PCI devices are in the system whether
> it causes any measureable slowdown.

I found this [1] from Paul Menzel, which was a slowdown caused by
quirk_usb_early_handoff().  I think the real problem is individual
quirks that take a long time.

The PCI_FIXUP_IOMMU things we're talking about should be fast, and of
course, they're only run for matching devices anyway.  So I'd rather
keep them as PCI_FIXUP_FINAL than add a whole new phase.

Bjorn

[1] https://lore.kernel.org/linux-pci/b1533fd5-1fae-7256-9597-36d3d5de9d2a@molgen.mpg.de/
