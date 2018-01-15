From: Chris Moore <moore@free.fr>
Subject: Re: [PATCH v2 1/3] crypto/generic: sha3 - fixes for alignment and big
 endian operation
Date: Mon, 15 Jan 2018 06:53:48 +0100
Message-ID: <cad7b34c-ca50-f856-c3fa-221b4c937d3e@free.fr>
References: <20180114164118.18330-1-ard.biesheuvel@linaro.org>
 <20180114164118.18330-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: steve.capper@linaro.org, herbert@gondor.apana.org.au,
        arnd@arndb.de, catalin.marinas@arm.com, will.deacon@arm.com,
        jgarzik@redhat.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:64790 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbeAOFx5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 00:53:57 -0500
In-Reply-To: <20180114164118.18330-2-ard.biesheuvel@linaro.org>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Le 14/01/2018 à 17:41, Ard Biesheuvel a écrit :
> Ensure that the input is byte swabbed before injecting it into the

Nitpick : s/swabbed/swapped/

> SHA3 transform. Use the get_unaligned() accessor for this so that
> we don't perform unaligned access inadvertently on architectures
> that do not support that.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Cheers,
Chris
