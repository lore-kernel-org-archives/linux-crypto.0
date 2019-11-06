Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02355C5DF63
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 15:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82E4218AE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 15:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oo1UA7Pi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbfKFPcx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:32:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33048 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727996AbfKFPcx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 10:32:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id w30so3635093wra.0
        for <linux-crypto@vger.kernel.org>; Wed, 06 Nov 2019 07:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=udfOIEK5WftU+3hJ0QWaj8LH2eZyxJmkc/JKt1seLOs=;
        b=Oo1UA7PiO7SaxQJEPN5EQ5Th2ShxZAZrUO9uMtn5LklEAg4p+CFSsXswLD6TjqgkSZ
         o6N9pCRQlASPd3hZR+rlelEShSeUGcTm0CffpexNgvvmx3GuMVYqdHFF0eKyolrKWuDm
         2VAYtHrQcTUtjSyuhe8iShFtlMHGqwjS627FjMWvWwlmWekx8A+o7Z+tAUraevHqMIuF
         mUD89fI3pOMIZWyzTozu3S4K7icOMkaxVA06e5rB9iOUj4x4zifn0+c8XecR+TAKhg+S
         DskFIyDjnIO/xZO31OLJ9nML1TO9CydXKZ38XvEp7o385hIuL3z1ajNB3+OPX3hPvv/M
         Ndsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=udfOIEK5WftU+3hJ0QWaj8LH2eZyxJmkc/JKt1seLOs=;
        b=WsRYP5uICKeJ4PXL2djFAiUjPOWDacH6yLBd9l29yjmGuDfMQC3WWYRFKLiBZaDsla
         XEAK+GccmJ+0mleq09+Y/1Iy8P6pYO+NUKd7uvkHn+82bDf2Vl41Qca38PpzHRL9zEL9
         fvLMeI7c3ltqEJ+aT5x/4jny0zKKVYgSCgPSBqWfpgWHmZuU5J3DBbCw/PaXdfrUqt5e
         TMZn9/3CID55qWkPPMoIv5mKj6608SKA/dloK8i6WhZPQ00K0Mh8Uxnoc/MFlhouRzRq
         zI0OwcpsjAGoXqe0WdrMkFahK4bGOGB4oH10yeDk2qAhj47Ck+4lCy+qoCeVBZy3d3we
         6Dqw==
X-Gm-Message-State: APjAAAUYoS6t9WedWvQdUZCIr19EWy0Cwk6F+4vHLMDvMai377E0IOvB
        jXumI0oES0KH0wRALwbwuycL9A==
X-Google-Smtp-Source: APXvYqxW2PJotobnvKVABwUffRMsszXhBfwOeRjonUD0JAktpL3nQ4x2pZhdtUJ/fqzmV6gMtsU9Zw==
X-Received: by 2002:a5d:634b:: with SMTP id b11mr3368850wrw.13.1573054369660;
        Wed, 06 Nov 2019 07:32:49 -0800 (PST)
Received: from lophozonia ([85.195.192.192])
        by smtp.gmail.com with ESMTPSA id f19sm11840wrf.23.2019.11.06.07.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 07:32:48 -0800 (PST)
Date:   Wed, 6 Nov 2019 16:32:46 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     zhangfei <zhangfei.gao@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v7 2/3] uacce: add uacce driver
Message-ID: <20191106153246.GA3695715@lophozonia>
References: <1572331216-9503-1-git-send-email-zhangfei.gao@linaro.org>
 <1572331216-9503-3-git-send-email-zhangfei.gao@linaro.org>
 <20191105114844.GA3648434@lophozonia>
 <24cbcd55-56d0-83b9-6284-04c29da11306@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <24cbcd55-56d0-83b9-6284-04c29da11306@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 06, 2019 at 04:17:40PM +0800, zhangfei wrote:
> > But I still believe it would be better to create an uacce_mm structure
> > that tracks all queues bound to this mm, and pass that to uacce_sva_exit
> > instead of the uacce_device.
> I am afraid this method may not work.
> Since currently iommu_sva_bind_device only accept the same drvdata for the
> same dev,
> that's the reason we can not directly use "queue" as drvdata.
> Each time create an uacce_mm structure should be same problem as queue, and
> fail for same dev.
> So we use uacce and pick up the right queue inside.

What I had in mind is keep one uacce_mm per mm and per device, and we can
pass that to iommu_sva_bind_device(). It requires some structure changes,
see the attached patch.

> > The queue isn't bound to a task, but its address space. With clone() the
> > address space can be shared between tasks. In addition, whoever has a
> > queue fd also gets access to this address space. So after a fork() the
> > child may be able to program the queue to DMA into the parent's address
> > space, even without CLONE_VM. Users must be aware of this and I think it's
> > important to explain it very clearly in the UAPI.
> > [...]
> > > +void uacce_unregister(struct uacce_device *uacce)
> > > +{
> > > +	if (!uacce)
> > > +		return;
> > > +
> > > +	mutex_lock(&uacce->q_lock);
> > > +	if (!list_empty(&uacce->qs)) {
> > > +		struct uacce_queue *q;
> > > +
> > > +		list_for_each_entry(q, &uacce->qs, list) {
> > > +			uacce_put_queue(q);
> > The open file descriptor will still exist after this function returns.
> > Can all fops can be called with a stale queue?
> To more clear:.
> Do you mean rmmod without fops_release.

Yes I think so. What happens when userspace starts some queues, and
the device driver suddenly calls uacce_unregister(). We call
cdev_device_del() later in this function, but quoting the documentation:
"any cdevs already open will remain and their fops will still be callable
even after this function returns." So we need to make sure that any of the
fops is safe to run after the uacce device disappears.

I noticed a lock dependency inversion on uacce->q_lock: uacce_unregister()
calls iommu_sva_unbind_device() while holding the uacce->q_lock, but
uacce_sva_exit() takes the uacce->q_lock with the SVA lock held. In theory
we could simply avoid calling iommu_sva_unbind_device() here since it will
be done by fops_release(), but then disabling the SVA feature in
uacce_unregister() won't work (because there still are bonds). The
attached patch should fix it, but I haven't tried running uacce_register()
yet.

Thanks,
Jean

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-uacce-Track-mm-queue-bonds.patch"

From 49559efc5cb26aadbcf580de03afd6e4ff67cedc Mon Sep 17 00:00:00 2001
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
Date: Wed, 6 Nov 2019 10:10:07 +0000
Subject: [PATCH] uacce: Track mm<->queue bonds

The IOMMU core only tracks mm<->device bonds at the moment, because it
only needs to handle IOTLB invalidation and PASID table entries. However
uacce needs a finer granularity since multiple queues from the same
device can be bound to an mm. When the mm exits, all bound queues must
be stopped so that the IOMMU can safely clear the PASID table entry and
reallocate the PASID.

Introduce an intermediate struct uacce_mm that links uacce devices and
queues. Note that an mm may be bound to multiple devices but an uacce_mm
structure only ever belongs to a single device, because we don't need
anything more complex (if multiple devices are bound to one mm, then
we'll create one uacce_mm for each bond).

        uacce_device --+-- uacce_mm --+-- uacce_queue
                       |              '-- uacce_queue
                       |
                       '-- uacce_mm --+-- uacce_queue
                                      +-- uacce_queue
                                      '-- uacce_queue

If multiple device drivers need this model, it should be possible to
move it to iommu-sva in the future, with some changes to the API, and
have mm_exit() be called for multiple contexts per iommu_bond.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/misc/uacce/uacce.c | 174 +++++++++++++++++++++++++++----------
 include/linux/uacce.h      |  34 ++++++--
 2 files changed, 152 insertions(+), 56 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 2b6b03855ac6..d8a7fbfe7399 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -92,15 +92,19 @@ static long uacce_fops_compat_ioctl(struct file *filep,
 static int uacce_sva_exit(struct device *dev, struct iommu_sva *handle,
 			  void *data)
 {
-	struct uacce_device *uacce = data;
+	struct uacce_mm *uacce_mm = data;
 	struct uacce_queue *q;
 
-	mutex_lock(&uacce->q_lock);
-	list_for_each_entry(q, &uacce->qs, list) {
-		if (q->pid == task_pid_nr(current))
-			uacce_put_queue(q);
-	}
-	mutex_unlock(&uacce->q_lock);
+	/*
+	 * No new queue can be added concurrently because no caller can have a
+	 * reference to this mm. But there may be concurrent calls to
+	 * uacce_mm_put(), so we need the lock.
+	 */
+	mutex_lock(&uacce_mm->lock);
+	list_for_each_entry(q, &uacce_mm->queues, list)
+		uacce_put_queue(q);
+	uacce_mm->mm = NULL;
+	mutex_unlock(&uacce_mm->lock);
 
 	return 0;
 }
@@ -109,13 +113,88 @@ static struct iommu_sva_ops uacce_sva_ops = {
 	.mm_exit = uacce_sva_exit,
 };
 
-static int uacce_fops_open(struct inode *inode, struct file *filep)
+static struct uacce_mm *uacce_mm_get(struct uacce_device *uacce,
+				     struct uacce_queue *q,
+				     struct mm_struct *mm)
 {
+	struct uacce_mm *uacce_mm = NULL;
 	struct iommu_sva *handle = NULL;
+	int ret;
+
+	lockdep_assert_held(&uacce->mm_lock);
+
+	list_for_each_entry(uacce_mm, &uacce->mm_list, list) {
+		if (uacce_mm->mm == mm) {
+			mutex_lock(&uacce_mm->lock);
+			list_add(&q->list, &uacce_mm->queues);
+			mutex_unlock(&uacce_mm->lock);
+			return uacce_mm;
+		}
+	}
+
+	uacce_mm = kzalloc(sizeof(*uacce_mm), GFP_KERNEL);
+	if (!uacce_mm)
+		return NULL;
+
+	if (uacce->flags & UACCE_DEV_SVA) {
+		/*
+		 * Safe to pass an incomplete uacce_mm, since mm_exit cannot
+		 * fire while we hold a reference to the mm.
+		 */
+		handle = iommu_sva_bind_device(uacce->pdev, mm, uacce_mm);
+		if (IS_ERR(handle))
+			goto err_free;
+
+		ret = iommu_sva_set_ops(handle, &uacce_sva_ops);
+		if (ret)
+			goto err_unbind;
+
+		uacce_mm->pasid = iommu_sva_get_pasid(handle);
+		if (uacce_mm->pasid == IOMMU_PASID_INVALID)
+			goto err_unbind;
+	}
+
+	uacce_mm->mm = mm;
+	uacce_mm->handle = handle;
+	INIT_LIST_HEAD(&uacce_mm->queues);
+	mutex_init(&uacce_mm->lock);
+	list_add(&q->list, &uacce_mm->queues);
+	list_add(&uacce_mm->list, &uacce->mm_list);
+
+	return uacce_mm;
+
+err_unbind:
+	if (handle)
+		iommu_sva_unbind_device(handle);
+err_free:
+	kfree(uacce_mm);
+	return NULL;
+}
+
+static void uacce_mm_put(struct uacce_queue *q)
+{
+	struct uacce_mm *uacce_mm = q->uacce_mm;
+
+	lockdep_assert_held(&q->uacce->mm_lock);
+
+	mutex_lock(&uacce_mm->lock);
+	list_del(&q->list);
+	mutex_unlock(&uacce_mm->lock);
+
+	if (list_empty(&uacce_mm->queues)) {
+		if (uacce_mm->handle)
+			iommu_sva_unbind_device(uacce_mm->handle);
+		list_del(&uacce_mm->list);
+		kfree(uacce_mm);
+	}
+}
+
+static int uacce_fops_open(struct inode *inode, struct file *filep)
+{
+	struct uacce_mm *uacce_mm = NULL;
 	struct uacce_device *uacce;
 	struct uacce_queue *q;
 	int ret = 0;
-	int pasid = 0;
 
 	uacce = xa_load(&uacce_xa, iminor(inode));
 	if (!uacce)
@@ -130,44 +209,37 @@ static int uacce_fops_open(struct inode *inode, struct file *filep)
 		goto out_with_module;
 	}
 
-	if (uacce->flags & UACCE_DEV_SVA) {
-		handle = iommu_sva_bind_device(uacce->pdev, current->mm, uacce);
-		if (IS_ERR(handle))
-			goto out_with_mem;
-
-		ret = iommu_sva_set_ops(handle, &uacce_sva_ops);
-		if (ret)
-			goto out_unbind;
+	q->state = UACCE_Q_ZOMBIE;
 
-		pasid = iommu_sva_get_pasid(handle);
-		if (pasid == IOMMU_PASID_INVALID)
-			goto out_unbind;
+	mutex_lock(&uacce->mm_lock);
+	uacce_mm = uacce_mm_get(uacce, q, current->mm);
+	mutex_unlock(&uacce->mm_lock);
+	if (!uacce_mm) {
+		ret = -ENOMEM;
+		goto out_with_mem;
 	}
 
+	q->uacce = uacce;
+	q->uacce_mm = uacce_mm;
+
 	if (uacce->ops->get_queue) {
-		ret = uacce->ops->get_queue(uacce, pasid, q);
+		ret = uacce->ops->get_queue(uacce, uacce_mm->pasid, q);
 		if (ret < 0)
-			goto out_unbind;
+			goto out_with_mm;
 	}
 
 	q->pid = task_pid_nr(current);
-	q->pasid = pasid;
-	q->handle = handle;
-	q->uacce = uacce;
 	memset(q->qfrs, 0, sizeof(q->qfrs));
 	init_waitqueue_head(&q->wait);
 	filep->private_data = q;
 	q->state = UACCE_Q_INIT;
 
-	mutex_lock(&uacce->q_lock);
-	list_add(&q->list, &uacce->qs);
-	mutex_unlock(&uacce->q_lock);
-
 	return 0;
 
-out_unbind:
-	if (uacce->flags & UACCE_DEV_SVA)
-		iommu_sva_unbind_device(handle);
+out_with_mm:
+	mutex_lock(&uacce->mm_lock);
+	uacce_mm_put(q);
+	mutex_unlock(&uacce->mm_lock);
 out_with_mem:
 	kfree(q);
 out_with_module:
@@ -182,12 +254,10 @@ static int uacce_fops_release(struct inode *inode, struct file *filep)
 
 	uacce_put_queue(q);
 
-	if (uacce->flags & UACCE_DEV_SVA)
-		iommu_sva_unbind_device(q->handle);
+	mutex_lock(&uacce->mm_lock);
+	uacce_mm_put(q);
+	mutex_unlock(&uacce->mm_lock);
 
-	mutex_lock(&uacce->q_lock);
-	list_del(&q->list);
-	mutex_unlock(&uacce->q_lock);
 	kfree(q);
 	module_put(uacce->pdev->driver->owner);
 
@@ -484,8 +554,8 @@ struct uacce_device *uacce_register(struct device *parent,
 		goto err_with_xa;
 	}
 
-	INIT_LIST_HEAD(&uacce->qs);
-	mutex_init(&uacce->q_lock);
+	INIT_LIST_HEAD(&uacce->mm_list);
+	mutex_init(&uacce->mm_lock);
 	uacce->cdev->ops = &uacce_fops;
 	uacce->cdev->owner = THIS_MODULE;
 	device_initialize(&uacce->dev);
@@ -519,20 +589,30 @@ EXPORT_SYMBOL_GPL(uacce_register);
  */
 void uacce_unregister(struct uacce_device *uacce)
 {
+	struct uacce_mm *uacce_mm;
+	struct uacce_queue *q;
+
 	if (!uacce)
 		return;
 
-	mutex_lock(&uacce->q_lock);
-	if (!list_empty(&uacce->qs)) {
-		struct uacce_queue *q;
-
-		list_for_each_entry(q, &uacce->qs, list) {
+	mutex_lock(&uacce->mm_lock);
+	list_for_each_entry(uacce_mm, &uacce->mm_list, list) {
+		/*
+		 * We don't take the uacce_mm->lock here. Since we hold the
+		 * device's mm_lock, no queue can be added to or removed from
+		 * this uacce_mm. We may run concurrently with mm_exit, but
+		 * uacce_put_queue() is serialized and iommu_sva_unbind_device()
+		 * waits for the lock that mm_exit is holding.
+		 */
+		list_for_each_entry(q, &uacce_mm->queues, list)
 			uacce_put_queue(q);
-			if (uacce->flags & UACCE_DEV_SVA)
-				iommu_sva_unbind_device(q->handle);
+
+		if (uacce->flags & UACCE_DEV_SVA) {
+			iommu_sva_unbind_device(uacce_mm->handle);
+			uacce_mm->handle = NULL;
 		}
 	}
-	mutex_unlock(&uacce->q_lock);
+	mutex_unlock(&uacce->mm_lock);
 
 	if (uacce->flags & UACCE_DEV_SVA)
 		iommu_dev_disable_feature(uacce->pdev, IOMMU_DEV_FEAT_SVA);
diff --git a/include/linux/uacce.h b/include/linux/uacce.h
index 04c8643c130b..8564e078287a 100644
--- a/include/linux/uacce.h
+++ b/include/linux/uacce.h
@@ -88,10 +88,9 @@ enum uacce_q_state {
  * @uacce: pointer to uacce
  * @priv: private pointer
  * @wait: wait queue head
- * @pasid: pasid of the queue
  * @pid: pid of the process using the queue
- * @handle: iommu_sva handle return from iommu_sva_bind_device
- * @list: queue list
+ * @list: index into uacce_mm
+ * @uacce_mm: the corresponding mm
  * @qfrs: pointer of qfr regions
  * @state: queue state machine
  */
@@ -99,10 +98,9 @@ struct uacce_queue {
 	struct uacce_device *uacce;
 	void *priv;
 	wait_queue_head_t wait;
-	int pasid;
 	pid_t pid;
-	struct iommu_sva *handle;
 	struct list_head list;
+	struct uacce_mm *uacce_mm;
 	struct uacce_qfile_region *qfrs[UACCE_QFRT_MAX];
 	enum uacce_q_state state;
 };
@@ -121,8 +119,8 @@ struct uacce_queue {
  * @cdev: cdev of the uacce
  * @dev: dev of the uacce
  * @priv: private pointer of the uacce
- * @qs: list head of queue->list
- * @q_lock: lock for qs
+ * @mm_list: list head of uacce_mm->list
+ * @mm_lock: lock for mm_list
  */
 struct uacce_device {
 	const char *algs;
@@ -137,8 +135,26 @@ struct uacce_device {
 	struct cdev *cdev;
 	struct device dev;
 	void *priv;
-	struct list_head qs;
-	struct mutex q_lock;
+	struct list_head mm_list;
+	struct mutex mm_lock;
+};
+
+/*
+ * struct uacce_mm - keep track of queues bound to a process
+ * @list: index into uacce_device
+ * @queues: list of queues
+ * @mm: the mm struct
+ * @lock: protects the list of queues
+ * @pasid: pasid of the queue
+ * @handle: iommu_sva handle return from iommu_sva_bind_device
+ */
+struct uacce_mm {
+	struct list_head list;
+	struct list_head queues;
+	struct mm_struct *mm;
+	struct mutex lock;
+	int pasid;
+	struct iommu_sva *handle;
 };
 
 #if IS_ENABLED(CONFIG_UACCE)
-- 
2.20.1


--3MwIy2ne0vdjdPXF--
