From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
Date: Tue, 20 Sep 2011 09:24:28 -0400
Message-ID: <1316525069.3189.4.camel@localhost.localdomain>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-security-module@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	Greg KH <greg@kroah.com>,
	"Serge E. Hallyn" <serge.hallyn@canonical.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <cover.1315921427.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2011-09-13 at 17:20 +0300, Dmitry Kasatkin wrote: 
> Hello,
> 
> Changes to version 2.0:
> - MPI patch has been split to smaller in order to go to mailing lists.
>   First 2 patches include only source and header files which are needed
>   to build ksign verification. Headers and sources are split just to
>   meet 100k kernel.org limit.
>   Last patch adds all rest soures from original ported MPI library.
>   
> Changes to version 1.1:
> - GnuPG MPI library has been refactored with lindent and checkpatch errors
>   and warnings has been fixed.
> - creation of evm keyring has been remove. It is done now in user space.
> - related ksign and evm patches has been squashed.
> - patch descriptions has been updated.
> 
> As EVM patches were recently merged to security-testing-2.6#next,
> it is a good time to resend evm signature verification patches for active
> discussion. Last time I forgot --cc linux-crypto. Here it is.
> 
> This patchset introduces digital signature extensions for the IMA/EVM kernel
> integrity subsystem and is applied on the top of the EVM patches posted to
> LSM mailing list earlier.

Hi Herbert

Back in March 2011, in preparation for EVM, Dmitry posted the GnuPG MPI
library patch here on linux-crypto. The reason given for not upstreaming
the MPI library, at the time, was for lack of an in kernel user
(http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05613.html).
With the recent merging of the EVM patches in linux-next, via
security-testing-2.6/#next, that is changing.  Any chance of re-opening
the discussion? 

thanks,

Mimi

