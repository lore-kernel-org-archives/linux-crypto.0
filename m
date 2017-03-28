From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 2/2] crypto: ccp - Mark driver as little-endian only
Date: Tue, 28 Mar 2017 09:08:57 -0500
Message-ID: <f5780ea9-3479-22df-30a6-c03f40803c0d@amd.com>
References: <20170328095814.3734615-1-arnd@arndb.de>
 <20170328095814.3734615-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0067.outbound.protection.outlook.com ([104.47.32.67]:45188
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752244AbdC1OJb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 10:09:31 -0400
In-Reply-To: <20170328095814.3734615-2-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ack. Didn't reply all....  Sorry, Arnd.

There was a krobot warning about this and I submitted a patch just now.

(I thought) my mistake was (in this function) not handling the structure
elements in the same manner as other functions. My patch rectifies that.

On 03/28/2017 04:58 AM, Arnd Bergmann wrote:
> The driver causes a warning when built as big-endian:
>
> drivers/crypto/ccp/ccp-dev-v5.c: In function 'ccp5_perform_des3':
> include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer
> implicitly truncated to unsigned type [-Werror=overflow]
>  #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
>                           ^
> include/linux/byteorder/generic.h:87:21: note: in expansion of macro
> '__cpu_to_le32'
>  #define cpu_to_le32 __cpu_to_le32
>                      ^~~~~~~~~~~~~
> drivers/crypto/ccp/ccp-dev-v5.c:436:28: note: in expansion of macro
> 'cpu_to_le32'
>   CCP5_CMD_KEY_MEM(&desc) = cpu_to_le32(CCP_MEMTYPE_SB);
>
> The warning is correct, doing a 32-bit byte swap on a value that gets
> assigned into a bit field cannot work, since we would only write zeroes
> in this case, regardless of the input.

Yes, this was all wrong.

> In fact, the use of bit fields in hardware defined data structures is
> not portable to start with, so until all these bit fields get replaced
> by something else, the driver cannot work on big-endian machines, and
> I'm adding an annotation here to prevent it from being selected.

This is a driver that talks to hardware, a device which, AFAIK, has no
plan to be implemented in a big endian flavor. I clearly need to be more
diligent in building with various checkers enabled. I'd prefer my fix
over your suggested refusal to compile, if that's okay.

> The CCPv3 code seems to not suffer from this problem, only v5 uses
> bitfields.

Yes, I took a different approach when I wrote the code. IMO (arguably)
more readable. Same result: words full of hardware-dependent bit patterns.

Please help me understand what I could do better.

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
