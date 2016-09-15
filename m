From: NTU <neotheuser@gmail.com>
Subject: Re: CONFIG_FIPS without module loading support?
Date: Wed, 14 Sep 2016 19:18:43 -0500
Message-ID: <CAM5Ud7OVvjh1WirzLh9YGzTqQn8qG8mNMe9+0rC7Q7E-0K7Yqg@mail.gmail.com>
References: <CAM5Ud7Pw84GcjpooX_5VfBuRTgU8+HMKkM6GBnD1z=JEw0PkXw@mail.gmail.com>
 <20160902142208.GA12938@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113eb96ce3bf3a053c80c9ce
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37559 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755074AbcIOASp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2016 20:18:45 -0400
Received: by mail-it0-f51.google.com with SMTP id 186so49968227itf.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2016 17:18:44 -0700 (PDT)
In-Reply-To: <20160902142208.GA12938@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--001a113eb96ce3bf3a053c80c9ce
Content-Type: text/plain; charset=UTF-8

Hello,

I've never written a patch before to the official kernel mailing list
(that I remember) so please forgive me if I didn't send this in
properly. I've generated this using git format-patch HEAD~ --stdout &>
kconfig_fix_for_fips.patch and have attached the file in this email,
gathering as much as I could from the Documentation/SubmittingPatches
page.

Few more things, in the help option for CRYPTO_ANSI_CPRNG, it says it
must be enabled if FIPS is selected, but in the dependencies for FIPS,
if DRBG is selected, then CRYPTO_ANSI_CPRNG doesn't need to be
enabled. Which one is true?

Secondly, in the help option for CRYPTO_DRBG_MENU, it says that one or
more of the DRBG types must be selected. If this is indeed true,
shouldn't the options within CRYPTO_DRBG_MENU be converted to
choice/endchoice versus just booleans? One selection for
CRYPTO_DRBG_HASH, another for CRYPTO_DRBG_CTR, and then a third option
for both? Should I submit patches for these as well,
feedback/thoughts?

Thank you!

Alec Ari

--001a113eb96ce3bf3a053c80c9ce
Content-Type: text/x-patch; charset=US-ASCII; name="kconfig_fix_for_fips.patch"
Content-Disposition: attachment; filename="kconfig_fix_for_fips.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_it3klmql0

RnJvbSAzZjZiNzg2ZWRlZjA5MDQyZmY3OGJjN2I0ZDYxZmM1YThmOGNmNjU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGVjIEFyaSA8bmVvdGhldXNlckBnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMTQgU2VwIDIwMTYgMTg6NTI6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBGaXggS2Nv
bmZpZyBkZXBlbmRlbmNpZXMgZm9yIEZJUFMKCkN1cnJlbnRseSBGSVBTIGRlcGVuZHMgb24gTU9E
VUxFX1NJRywgZXZlbiBpZiBNT0RVTEVTIGlzIGRpc2FibGVkLgpUaGlzIGNoYW5nZSBhbGxvd3Mg
dGhlIGVuYWJsaW5nIG9mIEZJUFMgd2l0aG91dCBzdXBwb3J0IGZvciBtb2R1bGVzLgoKSWYgbW9k
dWxlIGxvYWRpbmcgc3VwcG9ydCBpcyBlbmFibGVkLCBvbmx5IHRoZW4gZG9lcwpGSVBTIHJlcXVp
cmUgTU9EVUxFX1NJRy4KClNpZ25lZC1vZmYtYnk6IEFsZWMgQXJpIDxuZW90aGV1c2VyQGdtYWls
LmNvbT4KLS0tCiBjcnlwdG8vS2NvbmZpZyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2NyeXB0by9LY29uZmlnIGIvY3J5
cHRvL0tjb25maWcKaW5kZXggODRkNzE0OC4uZmQyODgwNSAxMDA2NDQKLS0tIGEvY3J5cHRvL0tj
b25maWcKKysrIGIvY3J5cHRvL0tjb25maWcKQEAgLTI0LDcgKzI0LDcgQEAgY29tbWVudCAiQ3J5
cHRvIGNvcmUgb3IgaGVscGVyIgogY29uZmlnIENSWVBUT19GSVBTCiAJYm9vbCAiRklQUyAyMDAg
Y29tcGxpYW5jZSIKIAlkZXBlbmRzIG9uIChDUllQVE9fQU5TSV9DUFJORyB8fCBDUllQVE9fRFJC
RykgJiYgIUNSWVBUT19NQU5BR0VSX0RJU0FCTEVfVEVTVFMKLQlkZXBlbmRzIG9uIE1PRFVMRV9T
SUcKKwlkZXBlbmRzIG9uIChNT0RVTEVfU0lHIHx8ICFNT0RVTEVTKQogCWhlbHAKIAkgIFRoaXMg
b3B0aW9ucyBlbmFibGVzIHRoZSBmaXBzIGJvb3Qgb3B0aW9uIHdoaWNoIGlzCiAJICByZXF1aXJl
ZCBpZiB5b3Ugd2FudCB0byBzeXN0ZW0gdG8gb3BlcmF0ZSBpbiBhIEZJUFMgMjAwCi0tIAoyLjcu
MwoK
--001a113eb96ce3bf3a053c80c9ce--
