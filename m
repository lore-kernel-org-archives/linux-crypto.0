From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Fri, 23 Dec 2016 11:16:50 +0530
Message-ID: <1b6fefca-d174-cd73-434b-7417d857f013@gmail.com>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com>
 <2943969.IiWKeGvEyD@tauon.atsec.com>
 <CAFXBA=ma8ZKeFfu-_DS1Nm=k0pwUatSabCmhwwwBMg45epOo_g@mail.gmail.com>
 <20161221085429.GB29501@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35051 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbcLWFq4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Dec 2016 00:46:56 -0500
Received: by mail-pf0-f194.google.com with SMTP id i88so13359582pfk.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Dec 2016 21:46:56 -0800 (PST)
In-Reply-To: <20161221085429.GB29501@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 21-12-2016 14:24, Herbert Xu wrote:
> On Mon, Dec 19, 2016 at 04:08:11PM +0530, Harsh Jain wrote:
>> Hi Herbert,
>>
>> TLS default mode of operation is MAC-then-Encrypt for Authenc algos.
>> Currently framework only supports EtM used in IPSec. User space
>> programs like openssl cannot use af-alg interface to encrypt/decrypt
>> in TLS mode.
>> Are we going to support Mac-then-Encrypt mode in future kernel releases?
> If someone finally adds TLS to the kernel then we'll likely do
> something about it.  
Till that time we cannot use crypto authenc type algos with AF-ALG socket interface for TLS or MtE( separation into 2 operation always not possible).  TLS RFC7366 allow users to decide weather to use EtM or MtE in TLS. We can solve this, If we have some way to communicate drivers  to operate in TLS mode like in setsockopt or msghdr of sendmsg.

> Otherwise you can just separate it out into
> two operations via af-alg.
 Always not possible. If openssl has software implementation of Authec( Cipher and hash with 1 algo) it expects same from af-alg engine only then he will override. Its like if Openssl has super set(AES+ SHA256) available it expect same super set in engine(af-alg) for comparison.
The machines with instruction set extensions has authenc implemented in user space like intel aes-ni.

>
> Cheers,
