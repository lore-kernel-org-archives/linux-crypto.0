From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
Date: Mon, 26 Sep 2011 10:33:48 +0300
Message-ID: <CALLzPKbPM-7Z4UphWvZUFxT9vF8XJSWyeUGTkLaM7--2A6y7eA@mail.gmail.com>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
	<1316525069.3189.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.hengli.com.au,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	Greg KH <greg@kroah.com>,
	"Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:21997 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808Ab1IZHdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 03:33:52 -0400
In-Reply-To: <1316525069.3189.4.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 20, 2011 at 4:24 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> =
wrote:
> On Tue, 2011-09-13 at 17:20 +0300, Dmitry Kasatkin wrote:
>> Hello,
>>
>> Changes to version 2.0:
>> - MPI patch has been split to smaller in order to go to mailing list=
s.
>> =C2=A0 First 2 patches include only source and header files which ar=
e needed
>> =C2=A0 to build ksign verification. Headers and sources are split ju=
st to
>> =C2=A0 meet 100k kernel.org limit.
>> =C2=A0 Last patch adds all rest soures from original ported MPI libr=
ary.
>>
>> Changes to version 1.1:
>> - GnuPG MPI library has been refactored with lindent and checkpatch =
errors
>> =C2=A0 and warnings has been fixed.
>> - creation of evm keyring has been remove. It is done now in user sp=
ace.
>> - related ksign and evm patches has been squashed.
>> - patch descriptions has been updated.
>>
>> As EVM patches were recently merged to security-testing-2.6#next,
>> it is a good time to resend evm signature verification patches for a=
ctive
>> discussion. Last time I forgot --cc linux-crypto. Here it is.
>>
>> This patchset introduces digital signature extensions for the IMA/EV=
M kernel
>> integrity subsystem and is applied on the top of the EVM patches pos=
ted to
>> LSM mailing list earlier.
>
> Hi Herbert
>
> Back in March 2011, in preparation for EVM, Dmitry posted the GnuPG M=
PI
> library patch here on linux-crypto. The reason given for not upstream=
ing
> the MPI library, at the time, was for lack of an in kernel user
> (http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05613.ht=
ml).
> With the recent merging of the EVM patches in linux-next, via
> security-testing-2.6/#next, that is changing. =C2=A0Any chance of re-=
opening
> the discussion?
>
> thanks,
>
> Mimi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-secur=
ity-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi,

It seems nobody wants to share their thoughts about it?
Does this silence mean acceptance?
Should I prepare final patches for merge?

BR,
Dmitry
