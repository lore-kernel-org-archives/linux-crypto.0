From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 0/2] crypto: KEYS: convert public key to akcipher api
Date: Thu, 10 Dec 2015 10:39:32 -0800
Message-ID: <5669C6E4.8030002@intel.com>
References: <20151209235226.11783.57073.stgit@tstruk-mobl1>
 <1449771957.2694.2.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, dhowells@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449771957.2694.2.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Mimi,
On 12/10/2015 10:25 AM, Mimi Zohar wrote:
>> This patch set converts the module verification and digital signature
>> > code to the new akcipher API.
>> > RSA implementation has been removed from crypto/asymmetric_keys and the
>> > new API is used for cryptographic primitives.
>> > There is no need for MPI above the akcipher API anymore.
>> > Modules can be verified with software as well as HW RSA implementations.
> With these two patches my system doesn't even boot.  Digging deeper...
> 

It needs RSA implementation built-in.
Could you check if you have CONFIG_CRYPTO_RSA=y
Thanks

-- 
TS
