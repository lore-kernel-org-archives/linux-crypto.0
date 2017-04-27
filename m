From: Mehmet Kayaalp <mkayaalp@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] ima: Support appended signatures for appraisal
Date: Thu, 27 Apr 2017 18:17:30 -0400
Message-ID: <027C5B04-376A-4340-9C6D-A5DB26327A3A@linux.vnet.ibm.com>
References: <201704201148.IPsFhl4B%fengguang.wu@intel.com>
 <35565259.p7kmk0rNRg@morokweng>
 <CDEBC6BB-7178-4891-9743-DD2B70328FCC@linux.vnet.ibm.com>
 <1565385.DQpqeaisNG@morokweng>
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
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1565385.DQpqeaisNG@morokweng>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> On Apr 27, 2017, at 5:41 PM, Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com> wrote:
> 
> Am Mittwoch, 26. April 2017, 18:18:34 BRT schrieb Mehmet Kayaalp:
>>> On Apr 20, 2017, at 7:41 PM, Thiago Jung Bauermann
>>> <bauerman@linux.vnet.ibm.com> wrote:
>>> 
>>> This patch introduces the appended_imasig keyword to the IMA policy syntax
>>> to specify that a given hook should expect the file to have the IMA
>>> signature appended to it. Here is how it can be used in a rule:
>>> 
>>> appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig
>>> appraise func=KEXEC_KERNEL_CHECK appraise_type=appended_imasig|imasig
>>> 
>>> In the second form, IMA will accept either an appended signature or a
>>> signature stored in the extended attribute. In that case, it will first
>>> check whether there is an appended signature, and if not it will read it
>>> from the extended attribute.
>>> 
>>> The format of the appended signature is the same used for signed kernel
>>> modules. This means that the file can be signed with the scripts/sign-file
>> 
>>> tool, with a command line such as this:
>> I would suggest naming the appraise_type as modsig (or some variant) to
>> clarify that the format is defined by how module signatures are handled.
>> Maybe we'd like to define a different appended/inline signature format for
>> IMA in the future.
> 
> I like the suggestion. Would that mean that we will keep refering to it as 
> "module signature format", and thus nothing changes in patch 5?

I think so. If we want IMA to own the format, we might want to go further than
just changing the word "module" in the marker. We might consider having more
flexibility and some additional fields, for example multiple signatures, or certificate
chains, ascii/binary encodings etc. We could maybe add a different type for CMS
Signed-Data.

Mehmet




