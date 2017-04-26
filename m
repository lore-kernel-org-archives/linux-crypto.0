From: Mehmet Kayaalp <mkayaalp@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ima: Support appended signatures for appraisal
Date: Wed, 26 Apr 2017 18:18:34 -0400
Message-ID: <CDEBC6BB-7178-4891-9743-DD2B70328FCC@linux.vnet.ibm.com>
References: <201704201148.IPsFhl4B%fengguang.wu@intel.com>
 <35565259.p7kmk0rNRg@morokweng>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        LSM <linux-security-module@vger.kernel.org>,
        linux-ima-devel@lists.sourceforge.net,
        keyrings <keyrings@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        kernel <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1031408AbdDZWOm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2017 18:14:42 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3QMDYij115032
        for <linux-crypto@vger.kernel.org>; Wed, 26 Apr 2017 18:14:42 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2a2ebvjccm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 26 Apr 2017 18:14:41 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <mkayaalp@linux.vnet.ibm.com>;
        Wed, 26 Apr 2017 18:14:41 -0400
In-Reply-To: <35565259.p7kmk0rNRg@morokweng>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On Apr 20, 2017, at 7:41 PM, Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> wrote:
> 
> This patch introduces the appended_imasig keyword to the IMA policy syntax
> to specify that a given hook should expect the file to have the IMA
> signature appended to it. Here is how it can be used in a rule:
> 
> appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig
> appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig|imasig
> 
> In the second form, IMA will accept either an appended signature or a
> signature stored in the extended attribute. In that case, it will first
> check whether there is an appended signature, and if not it will read it
> from the extended attribute.
> 
> The format of the appended signature is the same used for signed kernel
> modules. This means that the file can be signed with the scripts/sign-file
> tool, with a command line such as this:

I would suggest naming the appraise_type as modsig (or some variant) to clarify
that the format is defined by how module signatures are handled. Maybe we'd like 
to define a different appended/inline signature format for IMA in the future.

-Mehmet
