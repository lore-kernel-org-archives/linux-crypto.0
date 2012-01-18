From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver #3]
Date: Wed, 18 Jan 2012 17:20:40 +0200
Message-ID: <CALLzPKZ8voNPoyfTznq+_gPThbW6rqdGKLBztZ8qkesM2qtziQ@mail.gmail.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184406.21874.65285.stgit@warthog.procyon.org.uk>
	<CALLzPKZFShWGxxic8zMfTxoj6Q+t7-sC90wp5J790VRmg-O09g@mail.gmail.com>
	<26123.1326889583@redhat.com>
	<CALLzPKb4EycNZAd_80x-+p-iJ94CHerngOFZZmdrLpoJ+bYRMQ@mail.gmail.com>
	<29789.1326899624@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
	arjan.van.de.ven@intel.com, alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <29789.1326899624@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 18, 2012 at 5:13 PM, David Howells <dhowells@redhat.com> wr=
ote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
>
>> Yes. it is clear...
>> Would it be possible to have pass data (uncompleted) hash?
>
> Yes, provided it's not finalised. =C2=A0Also, with the current code i=
t would have
> to be a shash, but I think I should be able to support the passing in=
 of an
> async hash by exporting the state from that and importing the state i=
nto a
> shash using the crypto layer export and import functions.
>

I thought about export/import.
But I think export/Import is hash driver implementation specific...
Cannot use ahash state for shash...

As you said in repose to later patch, you could provide some function  =
to
build a final metadata buffer out of signature to finalize the hash...

- Dmitry


> David
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
