From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user
 selected rng
Date: Wed, 5 Jul 2017 14:09:31 +0200
Message-ID: <0954fe1d-e0ff-6b35-6d2d-96901cad6503@linux.vnet.ibm.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
 <1499076204-18547-4-git-send-email-freude@linux.vnet.ibm.com>
 <CANc+2y4SQhDdwbV+FLda9OwQpX=2fUsvDiD1eZE0QqQp1N+_hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751637AbdGEMJi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2017 08:09:38 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v65C95g8119078
        for <linux-crypto@vger.kernel.org>; Wed, 5 Jul 2017 08:09:37 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bgvtxqs2p-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 05 Jul 2017 08:09:36 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Wed, 5 Jul 2017 13:09:35 +0100
In-Reply-To: <CANc+2y4SQhDdwbV+FLda9OwQpX=2fUsvDiD1eZE0QqQp1N+_hg@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/04/2017 03:15 PM, PrasannaKumar Muralidharan wrote:
> On 3 July 2017 at 15:33, Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:
>> This patch introduces a new sysfs attribute file 'rng_selected'
>> which shows the the rng chosen by userspace.
>>
>> If a rng source is chosen by user via echo some valid string
>> to rng_current there should be a way to signal this choice to
>> userspace. The new attribute file 'rng_selected' shows either
>> the name of the rng chosen or 'none'.
>>
>> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
>> ---
>>  drivers/char/hw_random/core.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
>> index ffd4e36..6a6276a 100644
>> --- a/drivers/char/hw_random/core.c
>> +++ b/drivers/char/hw_random/core.c
>> @@ -28,8 +28,8 @@
>>  #define RNG_MODULE_NAME                "hw_random"
>>
>>  static struct hwrng *current_rng;
>> -/* the current rng has been explicitly chosen by user via sysfs */
>> -static int cur_rng_set_by_user;
>> +/* the rng explicitly selected by user via sysfs */
>> +static struct hwrng *selected_rng;
>>  static struct task_struct *hwrng_fill;
>>  /* list of registered rngs, sorted decending by quality */
>>  static LIST_HEAD(rng_list);
>> @@ -306,7 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>>         list_for_each_entry(rng, &rng_list, list) {
>>                 if (sysfs_streq(rng->name, buf)) {
>>                         err = 0;
>> -                       cur_rng_set_by_user = 1;
>> +                       selected_rng = rng;
>>                         if (rng != current_rng)
>>                                 err = set_current_rng(rng);
>>                         break;
>> @@ -355,16 +355,28 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>>         return strlen(buf);
>>  }
>>
>> +static ssize_t hwrng_attr_selected_show(struct device *dev,
>> +                                       struct device_attribute *attr,
>> +                                       char *buf)
>> +{
>> +       return snprintf(buf, PAGE_SIZE, "%s\n",
>> +                       selected_rng ? selected_rng->name : "none");
>> +}
>> +
>>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
>>                    hwrng_attr_current_show,
>>                    hwrng_attr_current_store);
>>  static DEVICE_ATTR(rng_available, S_IRUGO,
>>                    hwrng_attr_available_show,
>>                    NULL);
>> +static DEVICE_ATTR(rng_selected, S_IRUGO,
>> +                  hwrng_attr_selected_show,
>> +                  NULL);
>>
>>  static struct attribute *rng_dev_attrs[] = {
>>         &dev_attr_rng_current.attr,
>>         &dev_attr_rng_available.attr,
>> +       &dev_attr_rng_selected.attr,
>>         NULL
>>  };
>>
>> @@ -448,7 +460,7 @@ int hwrng_register(struct hwrng *rng)
>>         old_rng = current_rng;
>>         err = 0;
>>         if (!old_rng ||
>> -           (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
>> +           (!selected_rng && rng->quality > old_rng->quality)) {
>>                 /*
>>                  * Set new rng as current as the new rng source
>>                  * provides better entropy quality and was not
>> @@ -484,7 +496,7 @@ void hwrng_unregister(struct hwrng *rng)
>>         list_del(&rng->list);
>>         if (current_rng == rng) {
>>                 drop_current_rng();
>> -               cur_rng_set_by_user = 0;
>> +               selected_rng = NULL;
>>                 /* rng_list is sorted by quality, use the best (=first) one */
>>                 if (!list_empty(&rng_list)) {
>>                         struct hwrng *new_rng;
>> --
>> 2.7.4
>>
> The current_rng sysfs attribute shows currently selected rng. So this
> new attribute can contain 1 to indicate user's choice, 0 otherwise.
>
> Regards,
> PrasannaKumar
>
Here is an updated version with just showing 0 or 1 in the new sysfs
attribute file:
========== cut ==========
From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Date: Mon, 3 Jul 2017 10:19:22 +0200
Subject: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user selected
 rng

This patch introduces a new sysfs attribute file 'rng_selected'
which shows if the current rng has been chosen by userspace.

If a rng source is chosen by user via echo some valid string
to rng_current there should be a way to signal this choice to
userspace. The new attribute file 'rng_selected' shows '1' for
user selecte rng and '0' otherwise.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 drivers/char/hw_random/core.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index ffd4e36..2b4c7f6 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -28,8 +28,8 @@
 #define RNG_MODULE_NAME        "hw_random"
 
 static struct hwrng *current_rng;
-/* the current rng has been explicitly chosen by user via sysfs */
-static int cur_rng_set_by_user;
+/* the rng explicitly selected by user via sysfs */
+static struct hwrng *selected_rng;
 static struct task_struct *hwrng_fill;
 /* list of registered rngs, sorted decending by quality */
 static LIST_HEAD(rng_list);
@@ -306,7 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
     list_for_each_entry(rng, &rng_list, list) {
         if (sysfs_streq(rng->name, buf)) {
             err = 0;
-            cur_rng_set_by_user = 1;
+            selected_rng = rng;
             if (rng != current_rng)
                 err = set_current_rng(rng);
             break;
@@ -355,16 +355,27 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
     return strlen(buf);
 }
 
+static ssize_t hwrng_attr_selected_show(struct device *dev,
+                    struct device_attribute *attr,
+                    char *buf)
+{
+    return snprintf(buf, PAGE_SIZE, "%d\n", selected_rng ? 1 : 0);
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
 
@@ -448,7 +459,7 @@ int hwrng_register(struct hwrng *rng)
     old_rng = current_rng;
     err = 0;
     if (!old_rng ||
-        (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
+        (!selected_rng && rng->quality > old_rng->quality)) {
         /*
          * Set new rng as current as the new rng source
          * provides better entropy quality and was not
@@ -484,7 +495,7 @@ void hwrng_unregister(struct hwrng *rng)
     list_del(&rng->list);
     if (current_rng == rng) {
         drop_current_rng();
-        cur_rng_set_by_user = 0;
+        selected_rng = NULL;
         /* rng_list is sorted by quality, use the best (=first) one */
         if (!list_empty(&rng_list)) {
             struct hwrng *new_rng;
-- 
2.7.4
========== cut ==========
