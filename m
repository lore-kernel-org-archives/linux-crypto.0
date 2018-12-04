Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from namei.org ([65.99.196.166]:57642 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbeLDWAh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 17:00:37 -0500
Date: Wed, 5 Dec 2018 08:59:45 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Thiago Jung Bauermann <bauerman@linux.ibm.com>
cc: linux-integrity@vger.kernel.org,
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
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
Subject: Re: [PATCH v8 00/14] Appended signatures support for IMA appraisal
In-Reply-To: <20181116200712.14154-1-bauerman@linux.ibm.com>
Message-ID: <alpine.LRH.2.21.1812050855270.22148@namei.org>
References: <20181116200712.14154-1-bauerman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 16 Nov 2018, Thiago Jung Bauermann wrote:

> On the OpenPOWER platform, secure boot and trusted boot are being
> implemented using IMA for taking measurements and verifying signatures.
> Since the kernel image on Power servers is an ELF binary, kernels are
> signed using the scripts/sign-file tool and thus use the same signature
> format as signed kernel modules.
> 
> This patch series adds support in IMA for verifying those signatures.

Are you saying you use IMA to verify kernels during boot?  From a Linux 
bootloader?

> It adds flexibility to OpenPOWER secure boot, because it allows it to boot
> kernels with the signature appended to them as well as kernels where the
> signature is stored in the IMA extended attribute.

Just to clarify, with these patches, IMA will be able to verify the 
native form of signed kernel modules?  i.e. without xattrs at all, and 
this will work with existing signed modules?



-- 
James Morris
<jmorris@namei.org>
