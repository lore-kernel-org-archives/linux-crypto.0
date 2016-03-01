From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: crypto regression in 4.1.18: Check that kernel supports aes-cbc-essiv:sha256 cipher
Date: Tue, 01 Mar 2016 02:58:54 +0000
Message-ID: <20160301025853.GB17542@kroah.com>
References: <alpine.LRH.2.11.1603010129330.3635@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "Wang, Rui Y" <rui.y.wang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jean Delvare <jdelvare@suse.de>,
	<linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>
To: Eric Wheeler <linux-crypto@lists.ewheeler.net>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1603010129330.3635@mail.ewheeler.net>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 01, 2016 at 01:32:05AM +0000, Eric Wheeler wrote:
> Hello all,
> 
> We updated from 4.1.17 to 4.1.18 (same .config) and now get the following 
> error when trying to open a LUKS volume.  We've reverted to 4.1.17 and it 
> still works, so except that I'm not sure which commit caused the problem, 
> it is likely one of the recent commits:
> 
> When we `cryptsetup luksOpen` the volume we get this:
> 
>   Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for more info).  
> 
> Note that I do not see any dm-crypto commits so I don't think its a 
> dm-crypto issue. 
> 
> I'm happy to test, but can someone who knows the crypto stack suggest 
> which of these patches I should focus on for testing? These are the 
> commits in 4.1.18 that could be relevant:

There are some pending crypto backports to resolve this that hopefully
will show up in the next release, whenever Sasha gets to it.

thanks,

greg k-h
