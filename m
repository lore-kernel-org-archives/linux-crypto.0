From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 02/12] staging: ccree: move to kernel bitfields/bitops
Date: Mon, 29 May 2017 20:23:07 +0300
Message-ID: <CAOtvUMfPhPeD9LNG--KrXq+6n=BJR=L8_aSU_uyrgvY=UEeEsg@mail.gmail.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
 <1495982440-10047-3-git-send-email-gilad@benyossef.com> <20170529143844.GB12428@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34777 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdE2RXJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 13:23:09 -0400
Received: by mail-yw0-f194.google.com with SMTP id 5so3179445ywe.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 May 2017 10:23:08 -0700 (PDT)
In-Reply-To: <20170529143844.GB12428@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 29, 2017 at 5:38 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, May 28, 2017 at 05:40:27PM +0300, Gilad Ben-Yossef wrote:
>> ccree had a lot of boilerplate code for dealing with bitops
>> and bitfield register access. Move it over to the generic kernel
>> infrastructure used for doing the same.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> ---
>>  drivers/staging/ccree/cc_bitops.h        |  11 +-
>>  drivers/staging/ccree/cc_hw_queue_defs.h | 679 ++++++++++++-----------
>>  drivers/staging/ccree/ssi_aead.c         | 901 +++++++++++++++----------------
>>  drivers/staging/ccree/ssi_cipher.c       | 224 ++++----
>>  drivers/staging/ccree/ssi_driver.h       |   4 +-
>>  drivers/staging/ccree/ssi_fips_ll.c      | 704 ++++++++++++------------
>>  drivers/staging/ccree/ssi_hash.c         | 832 ++++++++++++++--------------
>>  drivers/staging/ccree/ssi_ivgen.c        |  77 ++-
>>  drivers/staging/ccree/ssi_request_mgr.c  |  25 +-
>>  drivers/staging/ccree/ssi_sram_mgr.c     |   8 +-
>>  10 files changed, 1765 insertions(+), 1700 deletions(-)
>>
>> diff --git a/drivers/staging/ccree/cc_bitops.h b/drivers/staging/ccree/cc_bitops.h
>> index ee5238a..a12a65c 100644
>> --- a/drivers/staging/ccree/cc_bitops.h
>> +++ b/drivers/staging/ccree/cc_bitops.h
>> @@ -21,9 +21,14 @@
>>  #ifndef _CC_BITOPS_H_
>>  #define _CC_BITOPS_H_
>>
>> -#define BITMASK(mask_size) (((mask_size) < 32) ?     \
>> -     ((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
>> -#define BITMASK_AT(mask_size, mask_offset) (BITMASK(mask_size) << (mask_offset))
>> +#include <linux/bitops.h>
>> +#include <linux/bitfield.h>
>> +
>> +#define BITMASK(mask_size) (((mask_size) < 32) ? \
>> +             ((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
>> +
>> +#define BITMASK_AT(mask_size, mask_offset) \
>> +     (BITMASK(mask_size) << (mask_offset))
>
> Why do you still needed these macros with this change?
>

My description of the patch is at fault. This patch gets rid of one
group of these
custom bit field ops users - and so does each one in the rest of the
series until
the patch that deletes them.

Getting rid of the custom bitfield ops was the reason why I've done
it, but of course
as you point it it isn't what the patch is doing. I will fix it.

>>
>>  #define BITFIELD_GET(word, bit_offset, bit_size) \
>>       (((word) >> (bit_offset)) & BITMASK(bit_size))
>> diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
>> index 7138176..af10850 100644
>> --- a/drivers/staging/ccree/cc_hw_queue_defs.h
>> +++ b/drivers/staging/ccree/cc_hw_queue_defs.h
>> @@ -22,25 +22,69 @@
>>  #include "cc_regs.h"
>>  #include "dx_crys_kernel.h"
>>
>> -/******************************************************************************
>> -*                            DEFINITIONS
>> -******************************************************************************/
>> -
>> -/* Dma AXI Secure bit */
>> -#define      AXI_SECURE      0
>> -#define AXI_NOT_SECURE       1
>> +/*****************************************************************************
>> + *                           DEFINITIONS
>> + *****************************************************************************/
>
> That has nothing to do with changing bitops :(
>
>>
>>  #define HW_DESC_SIZE_WORDS           6
>> -#define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
>> +#define HW_QUEUE_SLOTS_MAX              15 /* Max. available HW queue slots */
>
> Neither does this :(
>
> I'm stopping reviewing this here, please be more careful...

Thanks. I will fix and resend.

Gilad
-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
