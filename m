Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDBBCA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 17:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D1B821925
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 17:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UGplGApx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfJWRDT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:03:19 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38631 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbfJWRDT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 13:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571850198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hL1kplXLC+ueQfopd2mykU/6xLsfKNYy9p+amPVfFVA=;
        b=UGplGApx3GTROkZ/kqj1pOsV+1zvSdAQCcJhtB+yVWXMoUU0A4Co/te6jJZEJZVsYHOqqF
        JurrG6QAz3ZROhoxzuOeg11tmaOo1htMr/+myFE9yaMIixvU0kQd41PjlpeDAUfDbU2PA4
        2k8VOW56phVRjbxbmxW/FcCbeDGdYhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-JMqWU3XDM3WOQ86NKjFRPQ-1; Wed, 23 Oct 2019 13:03:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 939FA800D49;
        Wed, 23 Oct 2019 17:03:09 +0000 (UTC)
Received: from redhat.com (ovpn-124-105.rdu2.redhat.com [10.10.124.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 039751001B07;
        Wed, 23 Oct 2019 17:03:07 +0000 (UTC)
Date:   Wed, 23 Oct 2019 13:03:06 -0400
From:   Jerome Glisse <jglisse@redhat.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        francois.ozog@linaro.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zaibo Xu <xuzaibo@huawei.com>, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Wangzhou <wangzhou1@hisilicon.com>, grant.likely@arm.com,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        linux-accelerators@lists.ozlabs.org, kenneth-lee-2012@foxmail.com
Subject: Re: [PATCH v6 2/3] uacce: add uacce driver
Message-ID: <20191023170306.GC4163@redhat.com>
References: <1571214873-27359-1-git-send-email-zhangfei.gao@linaro.org>
 <1571214873-27359-3-git-send-email-zhangfei.gao@linaro.org>
 <20191016172802.GA1533448@lophozonia>
 <5da9a9cd.1c69fb81.9f8e8.60faSMTPIN_ADDED_BROKEN@mx.google.com>
 <20191023074227.GA264888@lophozonia>
MIME-Version: 1.0
In-Reply-To: <20191023074227.GA264888@lophozonia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: JMqWU3XDM3WOQ86NKjFRPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 23, 2019 at 09:42:27AM +0200, Jean-Philippe Brucker wrote:
> On Fri, Oct 18, 2019 at 08:01:44PM +0800, zhangfei.gao@foxmail.com wrote:

[...]

> > > > +static int uacce_fops_mmap(struct file *filep, struct vm_area_stru=
ct *vma)
> > > > +{
> > > > +=09struct uacce_queue *q =3D filep->private_data;
> > > > +=09struct uacce_device *uacce =3D q->uacce;
> > > > +=09struct uacce_qfile_region *qfr;
> > > > +=09enum uacce_qfrt type =3D 0;
> > > > +=09unsigned int flags =3D 0;
> > > > +=09int ret;
> > > > +
> > > > +=09if (vma->vm_pgoff < UACCE_QFRT_MAX)
> > > > +=09=09type =3D vma->vm_pgoff;
> > > > +
> > > > +=09vma->vm_flags |=3D VM_DONTCOPY | VM_DONTEXPAND;
> > > > +
> > > > +=09mutex_lock(&uacce_mutex);
>=20
> By the way, lockdep detects a possible unsafe locking scenario here,
> because we're taking the uacce_mutex even though mmap called us with the
> mmap_sem held for writing. Conversely uacce_fops_release() takes the
> mmap_sem for writing while holding the uacce_mutex. I think it can be
> fixed easily, if we simply remove the use of mmap_sem in
> uacce_fops_release(), since it's only taken to do some accounting which
> doesn't look right.

I think you need to remove the RLIMIT_DATA accounting altogether. Assume
it is not an issue for now and revisit latter when it becomes one as i
am not sure we want to add this queue memory accounting to RLIMIT_DATA
in the first place. Maybe a memory cgroup. In anycases it is safer to
delay this discussion to latter.

Cheers,
J=E9r=F4me

