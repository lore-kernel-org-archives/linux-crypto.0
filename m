Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50070CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 14:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17CBB21906
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 14:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UbcY2S3M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407368AbfJXOSM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:18:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405906AbfJXOSL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 10:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571926689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1702oBnAkkDkloBZidrcVo+vVTWenxIy5EZn+eImf0s=;
        b=UbcY2S3M1qA1DmOZsBSKmhH4Rjk56eXwWX6dm8qvqZprOUjN5ZNoE03jr6EMQC6AbNCvFh
        rcLtJRbZHYx/AqCCHVaA3DkxmviipwI0gz9UTGda9xKlnmGAgDu3znCKa47WU4T+G7gNgc
        Ls55e8TgnKV3cmHkyaWqhgQdByIhfYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-qxqBDIHWOzK-fIZtGMOReA-1; Thu, 24 Oct 2019 10:18:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD33A47B;
        Thu, 24 Oct 2019 14:18:04 +0000 (UTC)
Received: from redhat.com (ovpn-125-229.rdu2.redhat.com [10.10.125.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B5AC5D712;
        Thu, 24 Oct 2019 14:18:01 +0000 (UTC)
Date:   Thu, 24 Oct 2019 10:17:59 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Kenneth Lee <Kenneth-Lee-2012@foxmail.com>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        linux-accelerators@lists.ozlabs.org
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191024141759.GA4793@redhat.com>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191022184929.GC5169@redhat.com>
 <20191024064129.GB17723@kllp10>
MIME-Version: 1.0
In-Reply-To: <20191024064129.GB17723@kllp10>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: qxqBDIHWOzK-fIZtGMOReA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 24, 2019 at 02:41:29PM +0800, Kenneth Lee wrote:
> On Tue, Oct 22, 2019 at 02:49:29PM -0400, Jerome Glisse wrote:
> > Date: Tue, 22 Oct 2019 14:49:29 -0400
> > From: Jerome Glisse <jglisse@redhat.com>
> > To: Zhangfei Gao <zhangfei.gao@linaro.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann
> >  <arnd@arndb.de>, Herbert Xu <herbert@gondor.apana.org.au>,
> >  jonathan.cameron@huawei.com, grant.likely@arm.com, jean-philippe
> >  <jean-philippe@linaro.org>, ilias.apalodimas@linaro.org,
> >  francois.ozog@linaro.org, kenneth-lee-2012@foxmail.com, Wangzhou
> >  <wangzhou1@hisilicon.com>, "haojian . zhuang" <haojian.zhuang@linaro.o=
rg>,
> >  Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
> >  linux-crypto@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
> >  linux-accelerators@lists.ozlabs.org
> > Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
> > Message-ID: <20191022184929.GC5169@redhat.com>
> >=20
> > On Wed, Oct 16, 2019 at 04:34:32PM +0800, Zhangfei Gao wrote:
> > > From: Kenneth Lee <liguozhu@hisilicon.com>
> > >=20
> > > Uacce (Unified/User-space-access-intended Accelerator Framework) targ=
ets to
> > > provide Shared Virtual Addressing (SVA) between accelerators and proc=
esses.
> > > So accelerator can access any data structure of the main cpu.
> > > This differs from the data sharing between cpu and io device, which s=
hare
> > > data content rather than address.
> > > Since unified address, hardware and user space of process can share t=
he
> > > same virtual address in the communication.
> > >=20
> > > Uacce create a chrdev for every registration, the queue is allocated =
to
> > > the process when the chrdev is opened. Then the process can access th=
e
> > > hardware resource by interact with the queue file. By mmap the queue
> > > file space to user space, the process can directly put requests to th=
e
> > > hardware without syscall to the kernel space.
> >=20
> > You need to remove all API that is not use by your first driver as
> > it will most likely bit rot without users. It is way better to add
> > things when a driver start to make use of it.
>=20
> Yes. Good point. Thank you:)
>=20
> >=20
> > I am still not convince of the value of adding a new framework here
> > with only a single device as an example. It looks similar to some of
> > the fpga devices. Saddly because framework layering is not something
> > that exist i guess inventing a new framework is the only answer when
> > you can not quite fit into an existing one.
> >=20
> > More fundamental question is why do you need to change the IOMMU
> > domain of the device ? I do not see any reason for that unless the
> > PASID has some restriction on ARM that i do not know of.
>=20
> But I think this is the only way. As my understanding, by default, the
> system creates a DMA IOMMU domain for each device behine an IOMMU. If
> you want to call iommu interface directly, we have to rebind the device
> to an unmanaged domain.

Why would you need to call iommu directly ? On some GPUs we do use
PASID and we do not rebind to different domain, we just don't mess
with that. So i do not see any reason to change the domain.

Cheers,
J=E9r=F4me

