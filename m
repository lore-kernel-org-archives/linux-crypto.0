From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
Date: Mon, 28 Jan 2013 13:56:25 -0500
Message-ID: <20130128185625.GC5868@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
 <1358895228.2408.14.camel@falcor1>
 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
 <20130125210157.GA13152@redhat.com>
 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
 <20130128151527.GA5868@redhat.com>
 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com,
	jmorris@namei.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:

[..]
> > Ok. I am hoping that it will be more than the kernel command line we
> > support. In the sense that for digital signatures one needs to parse
> > the signature, look at what hash algorithm has been used  and then
> > collect the hash accordingly. It is little different then IMA requirement
> > of calculating one pre-determine hash for all files.
> 
> Yes... It is obvious. It's coming.
> But in general, signer should be aware of requirements and limitation
> of the platform.
> It is not really a problem...

One more question. I specified "ima_appraise_tcb" on kernel command line
and I had an unbootable system. It refused to run "init" as it was not
labeled/signed. Is there any policy/way where it appraises only signed
files and does not refuse to open/execute unsigned ones.

Thanks
Vivek
