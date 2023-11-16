Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 581 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Nov 2023 10:10:56 PST
Received: from 14.mo582.mail-out.ovh.net (14.mo582.mail-out.ovh.net [46.105.56.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C4E195
	for <linux-crypto@vger.kernel.org>; Thu, 16 Nov 2023 10:10:56 -0800 (PST)
Received: from director10.ghost.mail-out.ovh.net (unknown [10.108.16.176])
	by mo582.mail-out.ovh.net (Postfix) with ESMTP id A3F1324519
	for <linux-crypto@vger.kernel.org>; Thu, 16 Nov 2023 18:01:13 +0000 (UTC)
Received: from ghost-submission-6684bf9d7b-6c6xr (unknown [10.110.103.234])
	by director10.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 697E51FE0D;
	Thu, 16 Nov 2023 18:01:12 +0000 (UTC)
Received: from RCM-web10.webmail.mail.ovh.net ([151.80.29.18])
	by ghost-submission-6684bf9d7b-6c6xr with ESMTPSA
	id wLPAF+hYVmV/XQEApgZwCw
	(envelope-from <rafal@milecki.pl>); Thu, 16 Nov 2023 18:01:12 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 16 Nov 2023 19:01:12 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Rob
 Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Antoine Tenart <atenart@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: convert Inside Secure SafeXcel to
 the json-schema
In-Reply-To: <3f9f31e9-ead3-438a-bbd9-818b98ba1b3b@linaro.org>
References: <20231116130620.4787-1-zajec5@gmail.com>
 <3f9f31e9-ead3-438a-bbd9-818b98ba1b3b@linaro.org>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <844c8a5387ca4c5847bf8cfa82b8164c@milecki.pl>
X-Sender: rafal@milecki.pl
X-Originating-IP: 31.11.218.106
X-Webmail-UserID: rafal@milecki.pl
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6406651946374703905
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrudefkedguddtiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeggfffhvfevufgjfhgfkfigihgtgfesthekjhdttderjeenucfhrhhomheptfgrfhgrlhcuofhilhgvtghkihcuoehrrghfrghlsehmihhlvggtkhhirdhplheqnecuggftrfgrthhtvghrnhepvdehieeltdejheeltdfhffetgfetheejhefhffekfedukeeltdfhvdethfdtjedvnecuffhomhgrihhnpehrmhhilhgvtghkihdrlhhotggrlhdpshgthhgvmhgrrdhphienucfkphepuddvjedrtddrtddruddpfedurdduuddrvddukedruddtiedpudehuddrkedtrddvledrudeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeorhgrfhgrlhesmhhilhgvtghkihdrphhlqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheekvddpmhhouggvpehsmhhtphhouhht

On 2023-11-16 15:42, Krzysztof Kozlowski wrote:
>> +properties:
>> +  compatible:
>> +    oneOf:
>> +      - const: inside-secure,safexcel-eip197b
>> +      - const: inside-secure,safexcel-eip197d
>> +      - const: inside-secure,safexcel-eip97ies
>> +      - const: inside-secure,safexcel-eip197
>> +        description: Equivalent of inside-secure,safexcel-eip197b
>> +        deprecated: true
>> +      - const: inside-secure,safexcel-eip97
>> +        description: Equivalent of inside-secure,safexcel-eip97ies
>> +        deprecated: true
> 
> Wait, some new entries appear here and commit msg said nothing about
> changes in the binding. Commit says it is pure conversion. You must
> document all changes made.

I may make many mistakes but not one like that. I am phobic to adding
new stuff silently. All those entries were documented in .txt.


>> +allOf:
>> +  - if:
>> +      properties:
>> +        clocks:
>> +          minItems: 2
>> +    then:
>> +      required:
>> +        - clock-names
> 
> Did you test that it actually works? Considering other patchset which
> you did not, I have doubts that this was...

Sorry, I really have bad experience with Python due its maze of
dependencies and unfriendly feedback. I just wasted half an hour
debugging error like:

Traceback (most recent call last):
   File "/home/rmilecki/.local/bin/dt-doc-validate", line 64, in <module>
     ret |= check_doc(f)
   File "/home/rmilecki/.local/bin/dt-doc-validate", line 32, in 
check_doc
     for error in sorted(dtsch.iter_errors(), key=lambda e: e.linecol):
   File 
"/home/rmilecki/.local/lib/python3.10/site-packages/dtschema/schema.py", 
line 132, in iter_errors
     self.annotate_error(scherr, meta_schema, scherr.schema_path)
   File 
"/home/rmilecki/.local/lib/python3.10/site-packages/dtschema/schema.py", 
line 111, in annotate_error
     schema = schema[p]
KeyError: 'type'

which turned out to be a result of some outdated examples files.

I tested that binding thought. Still after another look at that allOf I
found one more corner case to cover.

-- 
Rafał Miłecki
