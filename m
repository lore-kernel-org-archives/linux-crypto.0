From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user
 selected rng
Date: Fri, 7 Jul 2017 12:22:41 +0200
Message-ID: <2cfcef13-2315-6bbe-4eda-ee019c870ce8@linux.vnet.ibm.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
 <1499076204-18547-4-git-send-email-freude@linux.vnet.ibm.com>
 <CANc+2y4SQhDdwbV+FLda9OwQpX=2fUsvDiD1eZE0QqQp1N+_hg@mail.gmail.com>
 <0954fe1d-e0ff-6b35-6d2d-96901cad6503@linux.vnet.ibm.com>
 <CANc+2y5T-SBi_3KP3zwzVcL__U8r6tzOub7PVkbDQn---Rm9EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54881 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750904AbdGGKWt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 06:22:49 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v67AIlfm015258
        for <linux-crypto@vger.kernel.org>; Fri, 7 Jul 2017 06:22:49 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bj443hkw9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jul 2017 06:22:49 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Fri, 7 Jul 2017 11:22:46 +0100
In-Reply-To: <CANc+2y5T-SBi_3KP3zwzVcL__U8r6tzOub7PVkbDQn---Rm9EA@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/06/2017 06:51 AM, PrasannaKumar Muralidharan wrote:
> Hi Harald,
>
>> Here is an updated version with just showing 0 or 1 in the new sysfs
>> attribute file:
>> ========== cut ==========
>> From: Harald Freudenberger <freude@linux.vnet.ibm.com>
>> Date: Mon, 3 Jul 2017 10:19:22 +0200
>> Subject: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user selected
>>  rng
>>
>> This patch introduces a new sysfs attribute file 'rng_selected'
>> which shows if the current rng has been chosen by userspace.
...
> Nice to see quick turn around time. Why not just use the
> cur_rng_set_by_user instead of selected_rng? This way patch 3 won't
> change things that patch 2 introduced and patch 3 will become much
> smaller. Also I feel folding patch 3 and 2 will make sense as both are
> related to user selected rng.
>
> Regards,
> PrasannaKumar
>
Hello PrasannaKumar

here is now a version which combines patch 2 and patch 3 together
according to your suggestions:

========== cut ==========

From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Date: Fri, 30 Jun 2017 17:06:40 +0200
Subject: [PATCH 2/2] crypto: hwrng remember rng chosen by user

When a user chooses a rng source via sysfs attribute
this rng should be sticky, even when other sources
with better quality to register. This patch introduces
a simple way to remember the user's choice. This is
reflected by a new sysfs attribute file 'rng_selected'
which shows if the current rng has been chosen by
userspace. The new attribute file shows '1' for user
selected rng and '0' otherwise.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 drivers/char/hw_random/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e9dda16..9701ac7 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -28,6 +28,8 @@
 #define RNG_MODULE_NAME        "hw_random"
 
 static struct hwrng *current_rng;
+/* the current rng has been explicitly chosen by user via sysfs */
+static int cur_rng_set_by_user;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
@@ -304,6 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
     list_for_each_entry(rng, &rng_list, list) {
         if (sysfs_streq(rng->name, buf)) {
             err = 0;
+            cur_rng_set_by_user = 1;
             if (rng != current_rng)
                 err = set_current_rng(rng);
             break;
@@ -352,16 +355,27 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
     return strlen(buf);
 }
 
+static ssize_t hwrng_attr_selected_show(struct device *dev,
+                    struct device_attribute *attr,
+                    char *buf)
+{
+    return snprintf(buf, PAGE_SIZE, "%d\n", cur_rng_set_by_user);
+}
+
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
            hwrng_attr_current_show,
            hwrng_attr_current_store);
 static DEVICE_ATTR(rng_available, S_IRUGO,
            hwrng_attr_available_show,
            NULL);
+static DEVICE_ATTR(rng_selected, S_IRUGO,
+           hwrng_attr_selected_show,
+           NULL);
 
 static struct attribute *rng_dev_attrs[] = {
     &dev_attr_rng_current.attr,
     &dev_attr_rng_available.attr,
+    &dev_attr_rng_selected.attr,
     NULL
 };
 
@@ -444,10 +458,12 @@ int hwrng_register(struct hwrng *rng)
 
     old_rng = current_rng;
     err = 0;
-    if (!old_rng || (rng->quality > old_rng->quality)) {
+    if (!old_rng ||
+        (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
         /*
          * Set new rng as current as the new rng source
-         * provides better entropy quality.
+         * provides better entropy quality and was not
+         * chosen by userspace.
          */
         err = set_current_rng(rng);
         if (err)
@@ -479,6 +495,7 @@ void hwrng_unregister(struct hwrng *rng)
     list_del(&rng->list);
     if (current_rng == rng) {
         drop_current_rng();
+        cur_rng_set_by_user = 0;
         /* rng_list is sorted by quality, use the best (=first) one */
         if (!list_empty(&rng_list)) {
             struct hwrng *new_rng;
-- 
2.7.4

========== cut ==========
