From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
Date: Mon, 15 Aug 2011 19:12:26 +0300
Message-ID: <4E49456A.4020506@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Can anyone please tell why this patch did not appear in archives?
I have received it in my 2 accounts, but I cannot see it in archive.
Is any size limitations??

- Dmitry


On 11/08/11 20:20, Dmitry Kasatkin wrote:
> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>
> Adds the multi-precision-integer maths library which was originally taken
> from GnuPG and ported to the kernel by (among others) David Howells.
> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
>
> This library is used to implemenet RSA digital signature verification
> used in IMA/EVM integrity protection subsystem.
>
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
