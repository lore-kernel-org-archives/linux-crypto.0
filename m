From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/3] crypto/generic: sha3 - fixes for alignment and big
 endian operation
Date: Mon, 15 Jan 2018 08:44:25 +0000
Message-ID: <CAKv+Gu_-DFR6iORh_Y=_a6+juL9UuaS1+3dvactqy0vkA0pWLw@mail.gmail.com>
References: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
 <20180114164118.18330-2-ard.biesheuvel@linaro.org> <cad7b34c-ca50-f856-c3fa-221b4c937d3e@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Steve Capper <steve.capper@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, jgarzik@redhat.com
To: Chris Moore <moore@free.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34603 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752943AbeAOIo0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 03:44:26 -0500
Received: by mail-io0-f171.google.com with SMTP id c17so12320999iod.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jan 2018 00:44:26 -0800 (PST)
In-Reply-To: <cad7b34c-ca50-f856-c3fa-221b4c937d3e@free.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 15 January 2018 at 05:53, Chris Moore <moore@free.fr> wrote:
> Hi,
>
> Le 14/01/2018 =C3=A0 17:41, Ard Biesheuvel a =C3=A9crit :
>>
>> Ensure that the input is byte swabbed before injecting it into the
>
>
> Nitpick : s/swabbed/swapped/
>

Thanks Chris - byte swapping is often referred to as swabbing, but I
guess 'byte swabbing' is redundant regardless.

>> SHA3 transform. Use the get_unaligned() accessor for this so that
>> we don't perform unaligned access inadvertently on architectures
>> that do not support that.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
>
> Cheers,
> Chris
>
