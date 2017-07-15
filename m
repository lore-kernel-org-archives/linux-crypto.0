From: sunil.m@techveda.org
Subject: [PATCH 0/3] staging: ccree: Employ devm_* functions, remove redundant code
Date: Sat, 15 Jul 2017 13:21:53 +0530
Message-ID: <1500105116-30290-1-git-send-email-sunil.m@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gregkh@linuxfoundation.org, gilad@benyossef.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Suniel Mahesh <sunil.m@techveda.org>

Hi

This patch series replaces the current API's which request
for device resources in driver probe, with devm_*() functions
of the kernel framework as recommended by the kernel community. 
Doing so simplifies driver cleanup paths and code organization.  

The current set of API's whch request for device resources are
not device managed.

The devm_*() functions of the kernel framework are kernel managed
resources which the kernel tracks and then automatically releases
them when the device goes away. 

Patch 1/3, replaces kzalloc with devm_kzalloc, kfree's and blank
lines are removed accordingly.

Patch 2/3, utilizes devm_ioremap_resource for map and unmap of 
device resources. 

request_mem_region(), ioremap() and corresponding error handling
is replaced with devm_ioremap_resource().
 
release_mem_region() and iounmap() are dropped. A struct member in
struct ssi_drvdata is dropped as it seemed redundant. Log messages
adjusted accordingly. 

Patch 3/3, replaces platform_get_resource(), request_irq() and 
corresponding error handling with platform_get_irq() and 
devm_request_irq(). 

free_irq is not required any more, devm_request_irq() free's it on 
driver detach. 

A struct member in struct ssi_drvdata and a bool variable in driver probe 
are dropped as they seemed redundant. 

Changed type of a member in struct ssi_drvdata to use it with platform_get_irq(). 
Log messages adjusted accordingly.

Note:
Patch was tested and built(ARCH=arm) on next-20170714.
No build issues reported, however it was not tested on
real hardware.

Please drop any patch if they break the flow. As per my
analysis these changes should not create a problem.

Thanks, Suniel 

Suniel Mahesh (3):
  staging: ccree: Replace kzalloc with devm_kzalloc
  staging: ccree: Convert to devm_ioremap_resource for map, unmap
  staging: ccree: Use platform_get_irq and devm_request_irq

 drivers/staging/ccree/ssi_driver.c | 92 +++++++++++---------------------------
 drivers/staging/ccree/ssi_driver.h |  4 +-
 2 files changed, 26 insertions(+), 70 deletions(-)

-- 
1.9.1
