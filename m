Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAB8C433E4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 22:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B10520792
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 22:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRqxl04k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgGWWlf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 18:41:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57247 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgGWWlf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 18:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595544094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNCEKJ42TJGwyjZg08MhJL5etwaa2Ujt2TOQmqOGcgw=;
        b=aRqxl04kevLCQea0YDh9fOe8zSvVHtj9encgI7qtN82aQlSICNb7OBQUZFfBDpuU6MXUSa
        rDu0/MEHmjbkSimswivclv8aOt6flZyPO1JS2ERDqhq27DEvjbuuifS94/SaNGoH2uex9m
        9sOVNWGsNplTQL6rCuMKle10Hwz2HJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-gkvHuhYuNrKcPEkSY9pgFw-1; Thu, 23 Jul 2020 18:41:30 -0400
X-MC-Unique: gkvHuhYuNrKcPEkSY9pgFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 860B018C63C9;
        Thu, 23 Jul 2020 22:41:28 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED6D274F58;
        Thu, 23 Jul 2020 22:41:26 +0000 (UTC)
Date:   Thu, 23 Jul 2020 16:41:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, cohuck@redhat.com, nhorman@redhat.com,
        vdronov@redhat.com, bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        fiona.trahe@intel.com, qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] vfio/pci: Add device denylist
Message-ID: <20200723164126.0249b247@w520.home>
In-Reply-To: <20200723214705.5399-3-giovanni.cabiddu@intel.com>
References: <20200723214705.5399-1-giovanni.cabiddu@intel.com>
        <20200723214705.5399-3-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 23 Jul 2020 22:47:02 +0100
Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:

> Add denylist of devices that by default are not probed by vfio-pci.
> Devices in this list may be susceptible to untrusted application, even
> if the IOMMU is enabled. To be accessed via vfio-pci, the user has to
> explicitly disable the denylist.
> 
> The denylist can be disabled via the module parameter disable_denylist.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 7c0779018b1b..673f53c4798e 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -60,6 +60,10 @@ module_param(enable_sriov, bool, 0644);
>  MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
>  #endif
>  
> +static bool disable_denylist;
> +module_param(disable_denylist, bool, 0444);
> +MODULE_PARM_DESC(disable_denylist, "Disable use of device denylist. Disabling the denylist prevents binding to devices with known errata that may lead to exploitable stability or security issues when accessed by untrusted users.");

s/prevents/allows/

ie. the denylist prevents binding, therefore disabling the denylist
allows binding

I can fix this on commit without a new version if you agree.  I also
see that patch 1/5 didn't change since v2, so I'll transfer Bjorn's
ack.  If that sounds good I'll queue the first 3 patches in my next
branch for v5.9.  Thanks,

Alex

> +
>  static inline bool vfio_vga_disabled(void)
>  {
>  #ifdef CONFIG_VFIO_PCI_VGA
> @@ -69,6 +73,29 @@ static inline bool vfio_vga_disabled(void)
>  #endif
>  }
>  
> +static bool vfio_pci_dev_in_denylist(struct pci_dev *pdev)
> +{
> +	return false;
> +}
> +
> +static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
> +{
> +	if (!vfio_pci_dev_in_denylist(pdev))
> +		return false;
> +
> +	if (disable_denylist) {
> +		pci_warn(pdev,
> +			 "device denylist disabled - allowing device %04x:%04x.\n",
> +			 pdev->vendor, pdev->device);
> +		return false;
> +	}
> +
> +	pci_warn(pdev, "%04x:%04x exists in vfio-pci device denylist, driver probing disallowed.\n",
> +		 pdev->vendor, pdev->device);
> +
> +	return true;
> +}
> +
>  /*
>   * Our VGA arbiter participation is limited since we don't know anything
>   * about the device itself.  However, if the device is the only VGA device
> @@ -1847,6 +1874,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct iommu_group *group;
>  	int ret;
>  
> +	if (vfio_pci_is_denylisted(pdev))
> +		return -EINVAL;
> +
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  
> @@ -2336,6 +2366,9 @@ static int __init vfio_pci_init(void)
>  
>  	vfio_pci_fill_ids();
>  
> +	if (disable_denylist)
> +		pr_warn("device denylist disabled.\n");
> +
>  	return 0;
>  
>  out_driver:

