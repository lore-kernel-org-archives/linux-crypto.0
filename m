From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 0/6] Appended signatures support for IMA appraisal
Date: Tue, 13 Jun 2017 20:18:51 +1000
Message-ID: <87tw3kgph0.fsf@concordia.ellerman.id.au>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com> <87d1adihhk.fsf@concordia.ellerman.id.au> <87efusyi3s.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-security-module@vger.kernel.org,
        Jessica Yu <jeyu@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        "AKASHI\, Takahiro" <takahiro.akashi@linaro.org>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-ima-devel@lists.sourceforge.net,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:46415 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751895AbdFMKSz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 06:18:55 -0400
In-Reply-To: <87efusyi3s.fsf@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> writes:

> Michael Ellerman <mpe@ellerman.id.au> writes:
>
>> Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> writes:
>>
>>> On the OpenPOWER platform, secure boot and trusted boot are being
>>> implemented using IMA for taking measurements and verifying signatures.
>>
>> I still want you to implement arch_kexec_kernel_verify_sig() as well :)
>
> Yes, I will implement it! We are still working on loading the public
> keys for kernel signing from the firmware into a kernel keyring, so
> there's not much point in implementing arch_kexec_kernel_verify_sig
> without having that first.

OK. What's the ETA on those patches?

cheers
