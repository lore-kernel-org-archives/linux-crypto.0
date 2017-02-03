From: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v5 0/3] Add Support for Cavium Cryptographic Acceleration Unit
Date: Fri, 3 Feb 2017 12:32:12 -0500
Message-ID: <CA+1xoqcWSdKtqvEQaGU+RQmxY3ZsH6L9G8_yFUODGcDksLuTiw@mail.gmail.com>
References: <1485779444-4332-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, david.daney@cavium.com,
        corentin labbe <clabbe.montjoie@gmail.com>,
        smueller@chronox.de,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>,
        alexander.levin@verizon.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33041 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdBCRcd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 12:32:33 -0500
In-Reply-To: <1485779444-4332-1-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 30, 2017 at 7:30 AM, George Cherian
<george.cherian@cavium.com> wrote:
> This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT)
> CPT is available in Cavium's Octeon-Tx SoC series.
>
> The series was tested with ecryptfs and dm-crypt for in kernel cryptographic
> offload operations. This driver needs a firmware to work, I will be sending the
> firmware to linux-firmware once the driver is accepted.

Can we have the firmware now to be able to actually test this series?
