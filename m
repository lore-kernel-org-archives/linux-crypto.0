From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/6] Appended signatures support for IMA appraisal
Date: Fri, 09 Jun 2017 18:19:19 -0300
Message-ID: <87efusyi3s.fsf@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com> <87d1adihhk.fsf@concordia.ellerman.id.au>
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
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55487 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751548AbdFIVTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2017 17:19:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v59LJbOU129150
        for <linux-crypto@vger.kernel.org>; Fri, 9 Jun 2017 17:19:53 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ayvkt9qug-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2017 17:19:53 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Fri, 9 Jun 2017 18:19:50 -0300
In-reply-to: <87d1adihhk.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Michael Ellerman <mpe@ellerman.id.au> writes:

> Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> writes:
>
>> On the OpenPOWER platform, secure boot and trusted boot are being
>> implemented using IMA for taking measurements and verifying signatures.
>
> I still want you to implement arch_kexec_kernel_verify_sig() as well :)

Yes, I will implement it! We are still working on loading the public
keys for kernel signing from the firmware into a kernel keyring, so
there's not much point in implementing arch_kexec_kernel_verify_sig
without having that first.

The same problem also affects IMA: even with these patches, new code
still neededs to be added to make IMA use the platform keys for kernel
signature verification.

-- 
Thiago Jung Bauermann
IBM Linux Technology Center
