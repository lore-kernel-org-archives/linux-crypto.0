From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
Date: Mon, 28 Jan 2013 20:48:55 -0500
Message-ID: <1359424135.3906.247.camel@falcor1>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
	 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
	 <1358895228.2408.14.camel@falcor1>
	 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
	 <20130125210157.GA13152@redhat.com>
	 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	 <20130128151527.GA5868@redhat.com>
	 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
	 <20130128185625.GC5868@redhat.com> <1359404149.3906.75.camel@falcor1>
	 <20130128202241.GB14405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	dhowells@redhat.com, jmorris@namei.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130128202241.GB14405@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2013-01-28 at 15:22 -0500, Vivek Goyal wrote:
> On Mon, Jan 28, 2013 at 03:15:49PM -0500, Mimi Zohar wrote:
> > On Mon, 2013-01-28 at 13:56 -0500, Vivek Goyal wrote:
> > > On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:
> > > 
> > > [..]
> > > > > Ok. I am hoping that it will be more than the kernel command line we
> > > > > support. In the sense that for digital signatures one needs to parse
> > > > > the signature, look at what hash algorithm has been used  and then
> > > > > collect the hash accordingly. It is little different then IMA requirement
> > > > > of calculating one pre-determine hash for all files.
> > > > 
> > > > Yes... It is obvious. It's coming.
> > > > But in general, signer should be aware of requirements and limitation
> > > > of the platform.
> > > > It is not really a problem...
> > > 
> > > One more question. I specified "ima_appraise_tcb" on kernel command line
> > > and I had an unbootable system. It refused to run "init" as it was not
> > > labeled/signed. Is there any policy/way where it appraises only signed
> > > files and does not refuse to open/execute unsigned ones.
> > 
> > The policy defines what needs to be measured/appraised, not the other
> > way around.  There's nothing preventing you from defining and loading a
> > different policy, one to your liking, before pivoting root.
> 
> Hi Mimi,
> 
> By policy you mean ima rules here? So I can either enable default rules
> (tcb default rules for appraisal and measurement) by using kernel command
> line options or dynamically configure my own rules using /sysfs interface?
> 
> If yes, AFAIK, existing inputtable policies do not allow this selective
> mode where we do appraisal only on signed executable. That means I shall
> have to extend the way policies can be specified so that one specify
> that appraise only signed files?

We've just added the ability of defining the method for appraising a
file and defining rules in terms of the filesystem UUID.  Extending the
IMA policy shouldn't be a problem, but I'm not sure how you would go
about adding support for only appraising files with digital signatures.

> Also given the fact that we allow loading policy from initramfs, root
> can rebuild initramfs and change the policy which takes effect over next
> reboot. So in priciple this works only when we are trying to impose some
> policy on non-root users?

The assumption has always been that the initramfs would be measured, for
trusted boot, and appraised, for secure boot, before being executed.

Mimi

