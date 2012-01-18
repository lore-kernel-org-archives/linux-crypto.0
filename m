From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 16/21] KEYS: PGP-based public key signature verification
 [ver #3]
Date: Wed, 18 Jan 2012 15:34:48 +0200
Message-ID: <CALLzPKb6v-F-Hh+TAifQyABb3TrSRy5Th8kc-3W48pykEoTc-Q@mail.gmail.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184548.21874.69507.stgit@warthog.procyon.org.uk>
	<CALLzPKbQb26jAqkkduSQGDDtFuNiCDf5F-HVYB-RJjF4+KLLeQ@mail.gmail.com>
	<26583.1326890996@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <26583.1326890996@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 18, 2012 at 2:49 PM, David Howells <dhowells@redhat.com> wr=
ote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
>
>> Synchronous hash SHASH is used only for software hash implementation=
=2E..
>> HW acceleration is not supported by this hash.
>> It is good for short data.
>> But when calculating a hash over long data as files can be,
>> async hash AHASH is a preferred choice as enables HW acceleration.
>
> Indeed. =C2=A0The asynchronous hash is a pain to use in the kernel, t=
hough, for a
> couple of reasons: kernel addresses don't necessarily correspond to a=
ddresses
> the h/w accel will see and you have to handle the h/w not signalling
> completion. =C2=A0Herbert created shash to make it easier, and for mo=
dule signing,
> they're perfectly sufficient.
>

Well, from client side, API is not that more complicate.
It is just about scatterlist. Rest is handled by particular driver/HW.

I agree, modules are not that big and SHASH is perfect choice for that.=
=2E.

>> As in my response to [PATCH 08/21] KEYS: Add signature verification =
facility
>> [ver #3] It would be nice to have API to pass pre-computed hash, the=
n client
>> might tackle async peculiarities by itself...
>
> True. =C2=A0If you can give me the completed hash data, then I don't =
need to care
> how you managed it. =C2=A0If you give me an uncompleted hash, I then =
have to deal
> with the async hash in the kernel.
>
> It might make sense for me to provide an API call to give you the pos=
tamble you
> need to add to the hash to complete it. =C2=A0That call could also in=
dicate which
> hash you require and could also be combined with the call to find the
> appropriate key.
>

Indeed, some blob with metadata to update before closing the hash
would work well.

PS.. As I understand, it is PGP spec which requires such processing.
Otherwise, plain data hash could be used to produce another hash for si=
gning,
similar to what has been done in digsig project.... I have used the
same approach for IMA.

Thanks!

> David
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
