From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: Re: [PATCH 1/3] crypto: caam: fix some compile warnings
Date: Wed, 4 Mar 2015 11:11:48 +0200
Message-ID: <54F6CC54.6090203@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
	<1425365453-19358-2-git-send-email-yanjiang.jin@windriver.com>
 <20150303125953.8585904680288a9734566b42@freescale.com>
 <54F66EA3.7080506@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ruchika.gupta@freescale.com>,
	<NiteshNarayanLal@freescale.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jinyanjiang@gmail.com>
To: yjin <yanjiang.jin@windriver.com>,
	Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F66EA3.7080506@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Yanjiang,

On 03/04/2015 04:32 AM, yjin wrote:
>
> On 2015=E5=B9=B403=E6=9C=8804=E6=97=A5 02:59, Kim Phillips wrote:
>> On Tue, 3 Mar 2015 14:50:51 +0800
>> <yanjiang.jin@windriver.com> wrote:
>>
>>> This commit is to avoid the below warnings:
>>>
>>> drivers/crypto/caam/sg_sw_sec4.h:88:12: warning:
>>> 'dma_map_sg_chained' defined but not used [-Wunused-function]
>>>   static int dma_map_sg_chained(struct device *dev, struct
>>> scatterlist *sg,
[...]
>
> We can find an example in Freescale SDK 1.6:
> caampkc.c includes pkc_desc.h, pkc_desc.h includes sg_sw_sec4.h, but
> caampkc.c doesn't call those functions.

This one was fixed in sdk-1.7 with the following patch:

diff --git a/drivers/crypto/caam/pkc_desc.h b/drivers/crypto/caam/pkc_d=
esc.h
index f73ad07..03013c2 100644
--- a/drivers/crypto/caam/pkc_desc.h
+++ b/drivers/crypto/caam/pkc_desc.h
@@ -20,7 +20,6 @@
 #include "desc_constr.h"
 #include "jr.h"
 #include "error.h"
-#include "sg_sw_sec4.h"
 #include <linux/crypto.h>
 #include "pdb.h"


Cristian S.
