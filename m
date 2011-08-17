From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
Date: Wed, 17 Aug 2011 13:38:45 +0200
Message-ID: <CAJU7zaKYRLO1yfNBZOho6LSczYr+PPvHT7zfmo=kSoVcM=O2ng@mail.gmail.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>
	<b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
	<4E49456A.4020506@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4E49456A.4020506@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 15, 2011 at 6:12 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> On 11/08/11 20:20, Dmitry Kasatkin wrote:
>> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>>
>> Adds the multi-precision-integer maths library which was originally taken
>> from GnuPG and ported to the kernel by (among others) David Howells.
>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
>> This library is used to implemenet RSA digital signature verification
>> used in IMA/EVM integrity protection subsystem.

Was there a particular reason to select the GnuPG mpi lib? Why not
include gmp (the gnupg mpi lib is a very old fork of gmp), or some other
big number library?

regards,
Nikos
