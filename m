From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 0/1] dm-integrity: integrity protection device-mapper target
Date: Mon, 24 Sep 2012 19:20:45 +0300
Message-ID: <CALLzPKbRk0NSS44Wq46SMPq7--NLG0+rjK8QxVfnaz25q=LX8Q@mail.gmail.com>
References: <cover.1348480396.git.dmitry.kasatkin@intel.com>
	<50606456.7020607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <50606456.7020607@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 24, 2012 at 4:47 PM, Milan Broz <mbroz@redhat.com> wrote:
> On 09/24/2012 11:55 AM, Dmitry Kasatkin wrote:
>> Both dm-verity and dm-crypt provide block level integrity protection.
>
> This is not correct. dm-crypt is transparent block encryption target,
> where always size of plaintext == size of ciphertext.
>

Of course... It is just said in relation to integrity protection.
It is said about encryption in following paragraphs...

> So it can provide confidentiality but it CANNOT provide integrity protection.
>

Yes, it provides confidentiality and via encryption it provides
certain level of integrity protection.
Data cannot be modified without being detected.
Decryption will result in garbage...

> We need extra space to store auth tag which dmcrypt cannot provide currently.
>
>> dm-integrity provides a lighter weight read-write block level integrity
>> protection for file systems not requiring full disk encryption, but
>> which do require writability.
>
> Obvious question: can be dm-verity extended to provide read-write integrity?
>

I think re-calculating hash trees all the time and syncing block
hashes and tree itself
is heavier operation...

> I would prefer to use standard mode like GCM to provide both encryption and
> integrity protection than inventing something new.

As said, if encryption is considered heavy operation in term of CPU
and battery usage
and also if encryption is not desired for some reasons that would be an option.

- Dmitry

>
> Milan
