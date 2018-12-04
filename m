Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbeLDXfY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 18:35:24 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wB4NUH3q005505
        for <linux-crypto@vger.kernel.org>; Tue, 4 Dec 2018 18:35:23 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p609cpyr6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 18:35:23 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Tue, 4 Dec 2018 23:35:22 -0000
References: <20181116200712.14154-1-bauerman@linux.ibm.com> <alpine.LRH.2.21.1812050855270.22148@namei.org>
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "AKASHI\, Takahiro" <takahiro.akashi@linaro.org>
Subject: Re: [PATCH v8 00/14] Appended signatures support for IMA appraisal
In-reply-to: <alpine.LRH.2.21.1812050855270.22148@namei.org>
Date: Tue, 04 Dec 2018 21:35:07 -0200
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87k1ko50ic.fsf@morokweng.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello James,

Thanks for you interest in these patches.

James Morris <jmorris@namei.org> writes:

> On Fri, 16 Nov 2018, Thiago Jung Bauermann wrote:
>
>> On the OpenPOWER platform, secure boot and trusted boot are being
>> implemented using IMA for taking measurements and verifying signatures.
>> Since the kernel image on Power servers is an ELF binary, kernels are
>> signed using the scripts/sign-file tool and thus use the same signature
>> format as signed kernel modules.
>>
>> This patch series adds support in IMA for verifying those signatures.
>
> Are you saying you use IMA to verify kernels during boot?  From a Linux
> bootloader?

Yes to both. OpenPOWER machines have embedded in their firmware a Linux
kernel and initramfs to use as bootloader, using Petitboot. kexec is
used to load the OS and boot it.

>> It adds flexibility to OpenPOWER secure boot, because it allows it to boot
>> kernels with the signature appended to them as well as kernels where the
>> signature is stored in the IMA extended attribute.
>
> Just to clarify, with these patches, IMA will be able to verify the
> native form of signed kernel modules?

That wasn't my use case to develop the patches, but I just tested and it
works.

I just had to make a slight modification: there's a whitelist of IMA
hooks that are allowed to use the module signature format (in the
ima_hook_supports_modsig function), and I had to add MODULE_CHECK to it.
The next version of the patches will have this change.

The only difference is that IMA looks for a valid key in the IMA
keyring, while the CONFIG_MODULE_SIG code looks for the module signing
key in the builtin and secondary trusted keyrings.

> i.e. without xattrs at all, and
> this will work with existing signed modules?

No xattrs at all, and yes.

--
Thiago Jung Bauermann
IBM Linux Technology Center
