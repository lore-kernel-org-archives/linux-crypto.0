From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: Duplicated module names
Date: Fri, 29 Jan 2016 15:58:20 +0000
Message-ID: <CAPKp9ub189GoMWm552=SL=VF5WaYAtwkJ+o2Dmn5=wTj=6GPBg@mail.gmail.com>
References: <56A91B6A.2060205@oracle.com>
	<CAKi4VA+MC=hXMQ2kHi4_Xv2w7qQcG443zj9+rKo_JKoSzgDvYQ@mail.gmail.com>
	<56AA98D6.7020305@oracle.com>
	<CAKi4VAKF-Ywm=VK4wzDdr-O0Fi8Gv8X--CQcJ4FFia0Gu1Xaeg@mail.gmail.com>
	<87h9hxrkvs.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
	Samson Yeung <samson.yeung@oracle.com>,
	linux-modules <linux-modules@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, David Airlie <airlied@linux.ie>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:36409 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbcA2P6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 10:58:21 -0500
In-Reply-To: <87h9hxrkvs.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 29, 2016 at 5:54 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> Hi!
>>
>> CC'ing Rusty and mailing lists
>
> Thanks.
>
>> Rusty and ohers: it looks like both CONFIG_CRC32 and
>> CONFIG_CRYPTO_CRC32 can be compiled as module, and they generate
>> modules with the same name, crc32.  Could that be fixed?
>
> Gah.  Looks like it's been that way since at least 2014, too.
>
> I think we could rename it to crypto_crc32, but I don't think it's the
> only one.  Marco, I think depmod should probably FAIL if two modules
> have the same name, which would at least find such problems.
>
> (BTW is there a nice way to figure out if a config var is a tristate?  These
> are only problematic if both CONFIG_ are tristate.)
>
> Here's a hacky attempt to look for problems:
>
> rusty@rusty-Lemur:~/devel/kernel/linux (master)$ KCONFIGS=`find * -name 'Kconfig*'`; for m in `find [b-z]* -name 'Makefile*'`; do sed -n 's,obj-\$(CONFIG.*+= \([a-z0-9_-]\+\.o\)$,'$m' \1,p' <$m | sort -u; done | sort -k 2 | uniq -D -f 1 | while read m obj; do fgrep -w $obj $m /dev/null; done | while read LINE; do conf=`echo $LINE | sed 's/.*\$(CONFIG_\([A-Z0-9_]*\).*/\1/'`; if grep -C2 "^config $conf\$" $KCONFIGS | fgrep -q tristate; then echo $LINE; fi; done
>
> Here are the results (mildly filtered by me):
>
[...]

>
> drivers/hwmon/Makefile:obj-$(CONFIG_SENSORS_VEXPRESS) += vexpress.o
> drivers/regulator/Makefile:obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o
>

Indeed causes issues if both are built as modules, only once succeeds.
I will post these 2 patches separately soon.

-->8

>From 1eb0d653d90e3f5fe05c6f63a17976226309e1ec Mon Sep 17 00:00:00 2001
From: Sudeep Holla <sudeep.holla@arm.com>
Date: Fri, 29 Jan 2016 15:40:24 +0000
Subject: [PATCH 1/2] hwmon: (vexpress) rename vexpress hwmon implementation

The vexpress hwmon implementation is currently just called vexpress.
This is a problem because it clashes with another module with the same
name in regulators.

This patch renames the vexpress hwmon implementation to vexpress-hwmon
so that there will be no clash in the module namespace.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/hwmon/Makefile                         | 2 +-
 drivers/hwmon/{vexpress.c => vexpress-hwmon.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/hwmon/{vexpress.c => vexpress-hwmon.c} (100%)

diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 30c94df31465..cfc09711810c 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -149,7 +149,7 @@ obj-$(CONFIG_SENSORS_TMP103) += tmp103.o
 obj-$(CONFIG_SENSORS_TMP401) += tmp401.o
 obj-$(CONFIG_SENSORS_TMP421) += tmp421.o
 obj-$(CONFIG_SENSORS_TWL4030_MADC)+= twl4030-madc-hwmon.o
-obj-$(CONFIG_SENSORS_VEXPRESS) += vexpress.o
+obj-$(CONFIG_SENSORS_VEXPRESS) += vexpress-hwmon.o
 obj-$(CONFIG_SENSORS_VIA_CPUTEMP)+= via-cputemp.o
 obj-$(CONFIG_SENSORS_VIA686A) += via686a.o
 obj-$(CONFIG_SENSORS_VT1211) += vt1211.o
diff --git a/drivers/hwmon/vexpress.c b/drivers/hwmon/vexpress-hwmon.c
similarity index 100%
rename from drivers/hwmon/vexpress.c
rename to drivers/hwmon/vexpress-hwmon.c
-- 
1.9.1

>From 1520bd20d3863df87ca5d9461bf5a20d3f58e385 Mon Sep 17 00:00:00 2001
From: Sudeep Holla <sudeep.holla@arm.com>
Date: Fri, 29 Jan 2016 15:44:50 +0000
Subject: [PATCH 2/2] regulator: vexpress: rename vexpress regulator
 implementation

The vexpress regulator implementation is currently just called vexpress.
This is a problem because it clashes with another module with the same
name in hardware monitors.

This patch renames the vexpress regulator implementation to
vexpress-regulator so that there will be no clash in the module namespace.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/regulator/Makefile                             | 2 +-
 drivers/regulator/{vexpress.c => vexpress-regulator.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/regulator/{vexpress.c => vexpress-regulator.c} (100%)

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 980b1943fa81..755077a89a25 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -98,7 +98,7 @@ obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_TPS80031) += tps80031-regulator.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
-obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o
+obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress-regulator.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
diff --git a/drivers/regulator/vexpress.c
b/drivers/regulator/vexpress-regulator.c
similarity index 100%
rename from drivers/regulator/vexpress.c
rename to drivers/regulator/vexpress-regulator.c
-- 
1.9.1
